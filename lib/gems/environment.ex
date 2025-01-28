defmodule GEMS.Environment do
  def load_envs(config_env) do
    Nvir.dotenv!([
      ".env",
      ".env.#{config_env}",
      overwrite: ".env.local.#{config_env}"
    ])
  end

  def ensure_env(env, type, default \\ nil) do
    case Nvir.env(env, type, default) do
      {:ok, value} -> value
      {:error, reason} -> abort!(reason)
    end
  end

  def ensure_game_path(env, default \\ nil) do
    case Nvir.env(env, &check_writable/1, default) do
      {:ok, expanded} -> expanded
      {:error, reason} -> abort!(reason)
    end
  end

  def ensure_secret(env) do
    case Nvir.env(env, &check_valid_secret/1) do
      {:ok, nil} -> random_secret_key_base()
      {:ok, secret} -> secret
      {:error, reason} -> abort!(reason)
    end
  end

  def check_valid_secret(secret) do
    case Nvir.cast(secret, :string?) do
      {:ok, secret}
      when byte_size(secret) < 64 ->
        {:error,
         """
         Cannot start GEMS because #{secret} must be at least 64 characters.
         Invoke `openssl rand -base64 48` to generate an appropriately long secret.
         """}

      {:ok, secret} ->
        {:ok, secret}
    end
  end

  defp check_writable(path) do
    case File.stat(path) do
      {:ok, %{type: :directory, access: access}}
      when access in [:read_write, :write] ->
        {:ok, Path.expand(path)}

      _anything_else ->
        {:error, "expected #{path} to be a writable directory"}
    end
  end

  defp random_secret_key_base() do
    Base.encode64(:crypto.strong_rand_bytes(48))
  end

  defp abort!(message) do
    IO.puts("\nERROR! #{inspect(message)}")
    System.halt(1)
  end
end
