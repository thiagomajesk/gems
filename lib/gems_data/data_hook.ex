defmodule GEMSData.DataHook do
  @moduledoc false

  alias GEMSData.DataFile

  defmacro __before_compile__(_) do
    quote location: :keep, bind_quoted: binding() do
      import GEMSData.DataHook

      data_files = load_data(@embeds)

      Module.put_attribute(__MODULE__, :lookup, data_files)

      for %{scope: scope, entries: entries, opts: opts} <- data_files do
        # Generate a zero-arity function to list entities per scope
        generate_scope_list_function(scope, entries)

        if key = Keyword.fetch!(opts, :lookup) do
          # Generate a one-arity function to lookup entities per scope
          generate_scope_lookup_function(scope, to_lookup(entries, key))
        end
      end

      # Generate fallback function to list entities per scope
      def list(_unknown_scope), do: nil

      # Generate fallback function to lookup entities per scope
      def lookup(_unknown_scope), do: nil
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

  defmacro generate_scope_lookup_function(scope, entries) do
    quote location: :keep, bind_quoted: binding() do
      @doc """
      Returns a map of entities grouped by their code in the #{scope} scope.
      """
      def lookup(unquote(scope)), do: unquote(Macro.escape(entries))
    end
  end

  @doc false
  def load_data(embeds) do
    opts = [max_concurrency: 10, ordered: false]

    embeds
    |> Task.async_stream(&DataFile.new/1, opts)
    |> Stream.map(fn {:ok, res} -> res end)
  end

  @doc false
  def to_lookup(entries, key) do
    Map.new(entries, &{Map.fetch!(&1, key), &1})
  end
end
