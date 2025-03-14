defmodule GEMSWeb.Game.BattleLive.DuelRoom do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    """
  end

  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character

    battle_metadata = GEMS.ActivityManager.fetch_state(character)

    if connected?(socket), do: GEMS.BattleManager.subscribe(character)

    {:ok, assign_current_battle_state(socket, battle_metadata)}
  end

  defp assign_current_battle_state(socket, _metadata) do
    socket
  end
end
