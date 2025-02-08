defmodule GEMSLua.Manager do
  use GenServer

  require Logger

  @utils Application.app_dir(:gems, "priv/lua")

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def attach_hook(name, callback, lua) do
    GenServer.cast(__MODULE__, {:attach_hook, name, callback, lua})
  end

  def trigger_hook(name, args \\ []) do
    # Hook calls need to be synchronous otherwise the calling process might terminate
    # the linked server and the hook will never be triggered (eg running mix tasks).
    GenServer.call(__MODULE__, {:trigger_hook, name, args})
  end

  @impl true
  def init(:ok) do
    paths = [@utils, GEMS.data_path()]
    {:ok, %{hooks: %{}, lua: initialize_sandbox(paths)}}
  end

  @impl true
  def handle_cast({:attach_hook, name, callback, lua}, state) do
    keys_path = [:hooks, Access.key(name, [])]
    {:noreply, put_in(state, keys_path, {callback, lua})}
  end

  @impl true
  def handle_call({:trigger_hook, name, args}, _from, state) do
    case get_in(state, [:hooks, name]) do
      nil ->
        {:reply, :noop, state}

      {callback, lua} ->
        # For now we just use the caller's lua state instead of the server's
        # state because hooks should be stateless (ie: not affect server's state).
        {result, _lua} = Lua.call_function!(lua, callback, args)

        {:reply, result, state}
    end
  end

  defp initialize_sandbox(paths) do
    opts = [exclude: [[:package], [:require]]]

    lua_paths = Enum.map(paths, &Path.join(&1, "?.lua"))
    init_paths = Enum.map(paths, &Path.join(&1, "init.lua"))

    lua =
      opts
      |> Lua.new()
      |> Lua.load_api(GEMSLua.API)
      |> Lua.load_api(GEMSLua.API.Hooks)
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
