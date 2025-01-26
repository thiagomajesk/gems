defmodule GEMS.Environment do
  def ensure_secret!(env) do
    case System.get_env(env) do
      nil ->
        random_secret_key_base()

      secret_key_base when byte_size(secret_key_base) < 64 ->
        abort!("""
        Cannot start GEMS because #{env} must be at least 64 characters.
        Invoke `openssl rand -base64 48` to generate an appropriately long secret.
        """)

      secret_key_base when is_binary(secret_key_base) ->
        secret_key_base
    end
  end

  def ensure_writable_dir!(env) do
    if dir = System.get_env(env) do
      if writable_dir?(dir),
        do: Path.expand(dir),
        else: abort!("expected #{env} to be a writable directory: #{dir}")
    end
  end

  def ensure_env!(env) do
    case System.get_env(env) do
      nil -> abort!("expected #{env} to be set")
      env -> env
    end
  end

  defp writable_dir?(path) do
    case File.stat(path) do
      {:ok, %{type: :directory, access: access}}
      when access in [:read_write, :write] ->
        true

      _anything_else ->
        false
    end
  end

  def random_secret_key_base() do
    Base.encode64(:crypto.strong_rand_bytes(48))
  end

  defp abort!(message) do
    IO.puts("\nERROR!!! [GEMS] #{message}")
    System.halt(1)
  end
end
