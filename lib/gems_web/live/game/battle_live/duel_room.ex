defmodule GEMSWeb.Game.BattleLive.DuelRoom do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      {inspect(@battle)}
    </div>
    """
  end

  def mount(%{"id" => identifier}, _session, socket) do
    battle = GEMS.BattleManager.fetch_state(identifier)

    if connected?(socket),
      do: {:ok, assign(socket, :battle, GEMS.Engine.Battler.run(battle))},
      else: {:ok, assign(socket, :battle, battle)}
  end
end
