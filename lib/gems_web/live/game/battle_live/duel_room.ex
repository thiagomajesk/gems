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
        <div class="flex items-center text-lg mb-4">
          <%= if action = turn.action do %>
            <div class="flex items-center justify-between w-full">
              <span>
                <strong>{turn.leader.name}</strong>
                used <strong class={affinity_color(action.affinity)}>{action.name}</strong>
              </span>
              <.action_points_indicator current={turn.action.action_cost} />
            </div>
          <% else %>
            <strong>{turn.leader.name}</strong>&nbsp;turn was skipped
          <% end %>
        </div>
        <ul class="flex flex-col gap-2">
          <li
            :for={event <- Enum.reverse(turn.events)}
            class="flex flex-col space-y-2 bg-gradient-to-r from-base-100 to-transparent rounded-box p-2"
          >
            <div class="flex items-center justify-between">
              <.outcome_icon outcome={event.outcome} />
            </div>
            <div class="flex items-center gap-2">
              <span class="font-medium text-blue-200">{event.caster.name}</span>
              attacked <span class="font-medium text-red-200">{event.target.name}</span>
              and it was a <strong class="text-cyan-200">{event.outcome}</strong>
            </div>
            <div :if={Enum.any?(event.logs)} class="flex items-center gap-2 flex-wrap mt-2">
              <.log_badge :for={log <- event.logs} log={log} />
            </div>
          </li>
        </ul>
        <div class="grid grid-cols-2 gap-4 mt-6">
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
    <div class="flex flex-col bg-base-200 rounded-box p-2">
      <span class="font-medium">{@actor.name} / {@actor.party}</span>
      <div class="flex flex-col gap-2">
        <.action_points_indicator current={@actor.action_points} />
        <div class="flex flex-col items-center gap-2">
          <progress
            class="progress text-rose-500"
            value={@actor.health}
            max={@actor.maximum_health}
            title={"#{@actor.health} / #{@actor.maximum_health}"}
          >
          </progress>
          <div class="flex items-center gap-2 w-full">
            <progress
              class="progress text-gray-400"
              value={@actor.physical_armor}
              max={@actor.maximum_physical_armor}
              title={"#{@actor.physical_armor} / #{@actor.maximum_physical_armor}"}
            >
            </progress>
            <progress
              class="progress text-cyan-500"
              value={@actor.magical_armor}
              max={@actor.maximum_magical_armor}
              title={"#{@actor.magical_armor} / #{@actor.maximum_magical_armor}"}
            >
            </progress>
          </div>
          <.conditions_preview actor={@actor} />
        </div>
      </div>
    </div>
    """
  end

  attr :actor, :any, required: true

  defp conditions_preview(assigns) do
    ~H"""
    <div class="flex items-center w-full justify-evenly">
      <span
        :if={@actor.burning_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Burning for #{@actor.burning_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:burning)} />
        <small>{@actor.burning_tokens}</small>
      </span>
      <span
        :if={@actor.poisoned_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Poisoned for #{@actor.poisoned_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:poisoned)} />
        <small>{@actor.poisoned_tokens}</small>
      </span>
      <span
        :if={@actor.frozen_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Frozen for #{@actor.frozen_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:frozen)} />
        <small>{@actor.frozen_tokens}</small>
      </span>
      <span
        :if={@actor.shocked_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Shocked for #{@actor.shocked_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:shocked)} />
        <small>{@actor.shocked_tokens}</small>
      </span>
      <span
        :if={@actor.bleeding_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Bleeding for #{@actor.bleeding_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:bleeding)} />
        <small>{@actor.bleeding_tokens}</small>
      </span>
      <span
        :if={@actor.stunned_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Stunned for #{@actor.stunned_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:stunned)} />
        <small>{@actor.stunned_tokens}</small>
      </span>
      <span
        :if={@actor.marked_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Marked for #{@actor.marked_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:marked)} />
        <small>{@actor.marked_tokens}</small>
      </span>
      <span
        :if={@actor.blighted_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Blighted for #{@actor.blighted_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:blighted)} />
        <small>{@actor.blighted_tokens}</small>
      </span>
      <span
        :if={@actor.silenced_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Silenced for #{@actor.silenced_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:silenced)} />
        <small>{@actor.silenced_tokens}</small>
      </span>
      <span
        :if={@actor.fortified_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Fortified for #{@actor.fortified_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:fortified)} />
        <small>{@actor.fortified_tokens}</small>
      </span>
      <span
        :if={@actor.vulnerable_tokens > 0}
        class="flex items-center gap-1 text-xs"
        title={"Vulnerable for #{@actor.vulnerable_tokens} turns"}
      >
        <UI.Icons.symbols {condition_attrs(:vulnerable)} />
        <small>{@actor.vulnerable_tokens}</small>
      </span>
    </div>
    """
  end

  attr :outcome, :any, required: true

  defp outcome_icon(assigns) do
    assigns =
      assign_new(assigns, :icon_attrs, fn
        %{outcome: :hit} -> %{name: "swords", class: "text-red-500"}
        %{outcome: :dodge} -> %{name: "directions-run", class: "text-gray-500"}
        %{outcome: :miss} -> %{name: "nearby-error", class: "text-gray-500"}
        %{outcome: :crit} -> %{name: "explosion-outline", class: "text-yellow-500"}
      end)

    ~H"""
    <span class="flex items-center text-lg gap-1">
      <UI.Icons.symbols {@icon_attrs} />
      <small class="font-semibold">
        {Recase.to_constant(Atom.to_string(@outcome))}
      </small>
    </span>
    """
  end

  attr :log, :any, required: true

  defp log_badge(assigns) do
    assigns = assign(assigns, extract_log_attrs(assigns.log))

    ~H"""
    <span class={["badge badge-soft", @badge_style]} title={inspect(@log)}>
      <UI.Icons.symbols name={@icon} />
      <small>{@display_value}</small>
    </span>
    """
  end

  attr :current, :integer, required: true

  defp action_points_indicator(assigns) do
    ~H"""
    <span class="flex items-center">
      <UI.Icons.symbols
        :for={value <- Enum.to_list(1..@current)}
        name="line-end-diamond"
        class="text-yellow-200"
        title={"#{value} Action Points"}
      />
    </span>
    """
  end

  defp affinity_color(:fire), do: "text-red-500"
  defp affinity_color(:water), do: "text-blue-500"
  defp affinity_color(:earth), do: "text-emerald-500"
  defp affinity_color(:air), do: "text-purple-500"
  defp affinity_color(:neutral), do: "text-gray-500"

  defp extract_log_attrs(%{type: :damage, metadata: %{"health" => health}}) do
    %{
      badge_style: "badge-error",
      icon: "heart-plus",
      color: "text-rose-500",
      display_value: "-#{health}"
    }
  end

  defp extract_log_attrs(%{type: :buff, metadata: %{"value" => value, "stat" => stat}}),
    do: %{
      badge_style: "badge-success",
      icon: "keyboard-double-arrow-up",
      display_value: "+#{format_stat(value)} to #{stat}"
    }

  defp extract_log_attrs(%{type: :debuff, metadata: %{"value" => value, "stat" => stat}}),
    do: %{
      badge_style: "badge-warning",
      icon: "keyboard-double-arrow-down",
      display_value: "-#{format_stat(value)} to #{stat}"
    }

  defp extract_log_attrs(%{type: :burning, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-red-500)]",
      icon: "local-fire-department",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :poisoned, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-emerald-500)]",
      icon: "water-drop",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :frozen, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-cyan-500)]",
      icon: "ac-unit",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :shocked, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-purple-500)]",
      icon: "bolt",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :bleeding, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-rose-500)]",
      icon: "water-drop",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :stunned, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-blue-500)]",
      icon: "atr",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :marked, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-orange-500)]",
      icon: "my-location",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :blighted, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-amber-500)]",
      icon: "coronavirus",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :silenced, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-gray-500)]",
      icon: "volume-off",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :fortified, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-green-500)]",
      icon: "verified-user",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(%{type: :vulnerable, metadata: %{"duration" => duration}}),
    do: %{
      badge_style: "[--badge-color:var(--color-yellow-500)]",
      icon: "gpp-maybe",
      display_value: "#{duration} turns"
    }

  defp extract_log_attrs(_), do: %{badge_style: nil, icon: nil, display_value: nil}

  defp condition_attrs(:burning), do: %{name: "local-fire-department", class: "text-red-500"}
  defp condition_attrs(:poisoned), do: %{name: "water-drop", class: "text-emerald-500"}
  defp condition_attrs(:frozen), do: %{name: "ac-unit", class: "text-cyan-500"}
  defp condition_attrs(:shocked), do: %{name: "bolt", class: "text-purple-500"}
  defp condition_attrs(:bleeding), do: %{name: "water-drop", class: "text-rose-500"}
  defp condition_attrs(:stunned), do: %{name: "atr", class: "text-blue-500"}
  defp condition_attrs(:marked), do: %{name: "my-location", class: "text-orange-500"}
  defp condition_attrs(:blighted), do: %{name: "coronavirus", class: "text-amber-500"}
  defp condition_attrs(:silenced), do: %{name: "volume-off", class: "text-gray-500"}
  defp condition_attrs(:fortified), do: %{name: "verified-user", class: "text-green-500"}
  defp condition_attrs(:vulnerable), do: %{name: "gpp-maybe", class: "text-yellow-500"}

  defp format_stat(value) when is_float(value),
    do: "#{trunc(value * 100)}%"

  defp format_stat(value), do: "#{value}"
end
