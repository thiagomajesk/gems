defmodule GEMSData.DataHook do
  @moduledoc false

  defmacro __before_compile__(_) do
    quote location: :keep, bind_quoted: binding() do
      import GEMSData.DataHook

      scope_lookup = load_data(@embeds)

      Module.put_attribute(__MODULE__, :lookup, scope_lookup)

      for {scope, entries} <- scope_lookup do
        # Generate a zero-arity function to list entities per scope
        generate_scope_list_function(scope, entries)

        # Generate a one-arity function to lookup entities per scope
        generate_scope_refs_function(scope, to_lookup(entries))
      end

      # Generate fallback function to list entities per scope
      def list(_unknown_scope), do: nil

      # Generate fallback function to lookup entities per scope
      def refs(_unknown_scope), do: nil
    end
  end

  defmacro generate_scope_list_function(scope, entries) do
    quote location: :keep, bind_quoted: binding() do
      @doc """
      Returns a list of all entities in the #{scope} scope.
      """
      def list(unquote(scope)), do: unquote(Macro.escape(entries))
    end
  end

  defmacro generate_scope_refs_function(scope, entries) do
    quote location: :keep, bind_quoted: binding() do
      @doc """
      Returns a map of entities grouped by their code in the #{scope} scope.
      """
      def refs(unquote(scope)), do: unquote(Macro.escape(entries))
    end
  end

  @doc false
  def load_data(embeds) do
    opts = [max_concurrency: 10, ordered: false]

    embeds
    |> Task.async_stream(&parse_file/1, opts)
    |> Stream.map(fn {:ok, res} -> res end)
    |> Stream.map(fn {scope, data} ->
      {scope, Enum.map(data, &hash_entry/1)}
    end)
  end

  @doc false
  def parse_file({scope, path}) do
    contents = File.read!(path)
    {scope, Jason.decode!(contents)}
  end

  @doc false
  def to_lookup(entries) do
    Map.new(entries, &{Map.fetch!(&1, "code"), &1})
  end

  @doc false
  def hash_entry(entry) do
    entry
    |> :erlang.term_to_binary()
    |> then(&:crypto.hash(:md5, &1))
    |> Base.encode16(case: :lower)
    |> then(&Map.put(entry, "__hash__", &1))
  end
end
