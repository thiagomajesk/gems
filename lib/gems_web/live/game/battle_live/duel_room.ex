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
          <.actor_card :for={actor <- @battle.actors} actor={actor} />
        </div>
      </section>
      <div
        :for={turn <- Enum.reverse(@battle.turns)}
        class="flex flex-col bg-base-300 rounded-box p-2 my-1"
      >
        <span>Number: {turn.number}</span>
        <span>
          <strong>
            {turn.leader.name} (Health: {turn.leader.health} \ Energy: {turn.leader.energy})
          </strong>
          used <strong>{get_in(turn.action.name)}</strong>
        </span>
        <ul class="flex flex-col gap-2">
          <li
            :for={event <- Enum.reverse(turn.events)}
            class="flex flex-col bg-base-200 rounded-box p-2"
          >
            <span>
              <span class="font-medium text-blue-200">
                {event.caster.name} (Health: {event.caster.health} \ Energy: {event.caster.energy})
              </span>
              did something to
              <span class="font-medium text-red-200">
                {event.target.name} (Health: {event.target.health} \ Energy: {event.target.energy})
              </span>
              and it was a <strong class="text-cyan-200">{event.outcome}</strong>
            </span>
            <div class="flex justify-between">
              <div class="flex items-center gap-2">
                <.effect_badge
                  :for={effect <- GEMS.Engine.Battler.Event.outcome_effects(event)}
                  effect={effect}
                />
              </div>
              <div class="flex items-center gap-2">
                <.status_effect_badge
                  :for={status_effect <- event.target.status_effects}
                  status_effect={status_effect}
                />
              </div>
            </div>
          </li>
        </ul>
        <div class="grid grid-cols-2 gap-4 mt-4">
          <.actor_card :for={actor <- turn.actors} actor={actor} />
        </div>
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

  attr :actor, :any, required: true

  defp actor_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-base-300 rounded-box p-2">
      <span class="font-medium">{@actor.name} / {@actor.party}</span>
      <div class="flex flex-col gap-1">
        <div class="flex flex-col items-center">
          <small class="text-right w-full">{@actor.health} / {@actor.maximum_health}</small>
          <progress class="progress text-rose-500" value={@actor.health} max={@actor.maximum_health}>
          </progress>
        </div>
        <div class="flex flex-col items-center">
          <small class="text-right w-full">{@actor.energy} / {@actor.maximum_energy}</small>
          <progress class="progress text-cyan-500" value={@actor.energy} max={@actor.maximum_energy}>
            {@actor.energy} / {@actor.maximum_energy}
          </progress>
        </div>
      </div>
    </div>
    """
  end

  attr :effect, :any, required: true

  defp effect_badge(assigns) do
    ~H"""
    <div class="badge badge-primary" title={inspect(@effect)}>
      <UI.Icons.game name="shield" />
    </div>
    """
  end

  attr :status_effect, :any, required: true

  defp status_effect_badge(assigns) do
    assigns =
      assign_new(assigns, :icon_classes, fn
        %{status_effect: %{type: :burning}} ->
          %{name: "small-fire", class: "text-red-500"}

        %{status_effect: %{type: :poisoned}} ->
          %{name: "drop", class: "text-green-500"}

        %{status_effect: %{type: :frozen}} ->
          %{name: "snowflake", class: "text-blue-500"}

        %{status_effect: %{type: :shocked}} ->
          %{name: "thunder", class: "text-yellow-500"}

        %{status_effect: %{type: :bleeding}} ->
          %{name: "blood", class: "text-red-500"}

        %{status_effect: %{type: :stunned}} ->
          %{name: "start-swirl", class: "text-yellow-500"}

        %{status_effect: %{type: :marked}} ->
          %{name: "targeted", class: "text-red-500"}

        %{status_effect: %{type: :blighted}} ->
          %{name: "blood", class: "text-yellow-500"}

        %{status_effect: %{type: :silenced}} ->
          %{name: "silenced", class: "text-yellow-500"}

        %{status_effect: %{type: :buff}} ->
          %{name: "upgrade", class: "text-green-500"}

        %{status_effect: %{type: :debuff}} ->
          %{name: "upgrade", rotate: 180, class: "text-red-500"}
      end)

    ~H"""
    <div class="badge" title={inspect(@status_effect)}>
      <UI.Icons.game {@icon_classes} />
    </div>
    """
  end
end
