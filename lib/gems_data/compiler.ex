defmodule GEMSData.Compiler do
  @moduledoc """
  Compiles JSON files from a given folder and transforms its entries into functions that
  can later be used to lookup data using the code key. Because of this all entries in the
  file are required to have a code, if we can't find it in the object, compilation fails.
  """

  @doc """
  Reads a data from JSON files and compiles into the module.
  """
  defmacro embed_data(scope, pattern) do
    quote location: :keep, bind_quoted: binding() do
      for path <- Path.wildcard(pattern) do
        Module.put_attribute(__MODULE__, :embeds, {scope, path})
        Module.put_attribute(__MODULE__, :external_resource, path)
      end
    end
  end

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: binding() do
      import GEMSData.Compiler

      @before_compile GEMSData.DataHook
      Module.register_attribute(__MODULE__, :embeds, accumulate: true)
    end
  end
end
