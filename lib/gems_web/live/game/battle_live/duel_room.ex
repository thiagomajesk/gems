defmodule GEMSWeb.Game.BattleLive.DuelRoom do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <span>Status: {@battle.status}</span>
      <span>Type: {@battle.type}</span>
      <span>Turns: {length(@battle.turns)}</span>
      <section class="flex flex-col items-center">
        <header>Actors</header>
        <div class="grid grid-cols-2 gap-4 my-4 w-full">
          <div :for={actor <- @battle.actors}>
            <div class="flex flex-col bg-base-300 rounded-box p-2">
              <span class="font-medium">{actor.name} / {actor.party}</span>
              <div class="flex flex-col gap-1">
                <progress
                  class="progress text-rose-500"
                  value={actor.health}
                  max={actor.maximum_health}
                >
                </progress>
                <progress
                  class="progress text-cyan-500"
                  value={actor.energy}
                  max={actor.maximum_energy}
                />
              </div>
            </div>
          </div>
        </div>
      </section>
      <div
        :for={turn <- Enum.reverse(@battle.turns)}
        class="flex flex-col bg-base-300 rounded-box p-2 my-1"
      >
        <span>Number: {turn.number}</span>
        <span>{turn.leader.name} used...</span>
        <span>Action: {get_in(turn.action.name)}</span>
        <ul class="bg-base-100 divider-y space-y-2">
          <li :for={event <- turn.events} class="flex flex-col">
            <span>{event.icon}</span>
            <span>{event.origin}</span>
            <span>{event.timestamp}</span>
            <span>{inspect(event.effect)}</span>
            <span>{event.target.name}</span>
          </li>
        </ul>
      </div>
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
