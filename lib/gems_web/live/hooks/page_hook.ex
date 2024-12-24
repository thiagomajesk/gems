defmodule GEMSWeb.PageHook do
  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4]

  def on_mount(:current_path, _params, _session, socket) do
    {:cont, attach_hook(socket, :assign_current_path, :handle_params, &assign_current_path/3)}
  end

  defp assign_current_path(_params, uri, socket) do
    %{path: current_path} = URI.parse(uri)
    {:cont, assign(socket, :current_path, current_path)}
  end
end
