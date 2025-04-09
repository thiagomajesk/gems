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
              <div class="flex items-center gap-2 flex-wrap">
                <.log_badge :for={log <- event.logs} log={log} />
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

  attr :log, :any, required: true

  defp log_badge(assigns) do
    assigns = assign(assigns, extract_log_attrs(assigns.log))

    ~H"""
    <span class={["badge badge-soft", @badge_style]} title={inspect(@log)}>
      <UI.Icons.page name={@icon} />
      <small>{@display_value}</small>
    </span>
    """
  end

  defp extract_log_attrs(%{type: :damage, metadata: %{"health" => health}}) do
    %{
      badge_style: "badge-error",
      icon: "heart",
      color: "text-rose-500",
      display_value: "-#{health}"
    }
  end

  defp extract_log_attrs(%{type: :damage, metadata: %{"energy" => energy}}) do
    %{badge_style: "badge-error", icon: "bolt", display_value: energy}
  end

  defp extract_log_attrs(%{type: :buff, metadata: %{"value" => value, "stat" => stat}}),
    do: %{
      badge_style: "badge-success",
      icon: "chevrons-up",
      display_value: "+#{format_stat(value)} to #{stat}"
    }

  defp extract_log_attrs(%{type: :debuff, metadata: %{"value" => value, "stat" => stat}}),
    do: %{
      badge_style: "badge-warning",
      icon: "chevrons-down",
      display_value: "-#{format_stat(value)} to #{stat}"
    }

  defp extract_log_attrs(%{type: :burning, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-red-500)]",
      icon: "flame",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :poisoned, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-emerald-500)]",
      icon: "droplet",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :frozen, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-cyan-500)]",
      icon: "snowflake",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :shocked, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-purple-500)]",
      icon: "zap",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :bleeding, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-rose-500)]",
      icon: "droplet",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :stunned, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-blue-500)]",
      icon: "sparkles",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :marked, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-orange-500)]",
      icon: "crosshair",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :blighted, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-amber-500)]",
      icon: "droplet",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :silenced, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-gray-500)]",
      icon: "volume-x",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(_), do: %{badge_style: nil, icon: nil, display_value: nil}

  defp format_stat(value) when is_float(value),
    do: "#{trunc(value * 100)}%"

  defp format_stat(value), do: "#{value}"
end
