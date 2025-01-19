defmodule GEMSLua.Manager do
  use GenServer

  require Logger

  @utils Application.app_dir(:gems, "priv/lua")

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    paths = [@utils, GEMS.data_path()]
    {:ok, %{lua: initialize_sandbox(paths)}}
  end

  defp initialize_sandbox(paths) do
    opts = [exclude: [[:package], [:require]]]

    lua_paths = Enum.map(paths, &Path.join(&1, "?.lua"))
    init_paths = Enum.map(paths, &Path.join(&1, "init.lua"))

    lua =
      opts
      |> Lua.new()
      |> Lua.load_api(GEMSLua.API)
      |> Lua.load_api(GEMSLua.API.Seeds)
      |> Lua.set_lua_paths(lua_paths)

    # Load all init.lua files
    init_paths
    |> Enum.filter(&File.exists?/1)
    |> Enum.reduce(lua, &safe_load(&2, &1))
  end

  # Created to safe load lua files while the issue is not fixed.
  # See here for more details: https://github.com/tv-labs/lua/issues/61.
  defp safe_load(lua, path) do
    Logger.info("Loading lua file: \n #{path}")
    Lua.load_file!(lua, path)
  catch
    :error, {:case_clause, {:eof, _lines}} ->
      Logger.info("Lua file has no instructions, skipping: \n #{path}")
      lua
  end
end
