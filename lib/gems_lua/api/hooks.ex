defmodule GEMSLua.API.Hooks do
  use Lua.API, scope: "GEMS.api.hooks"

  deflua on_seeds(callback), lua, do: add_hook(:on_seeds, callback, lua)

  defp add_hook(:on_seeds, callback, lua) when is_function(callback, 1) do
    GEMSLua.Manager.attach_hook(:on_seeds, callback, lua)
  end

  defp add_hook(hook, callback, _lua),
    do: raise("Unknown hook: #{inspect(hook)} with callback: #{inspect(callback)}")
end
