defmodule GEMSWeb.BattleLive.Room do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <div :if={!@battle}>Loading...</div>
    <div :if={@battle}>
      <h1 class="text-2xl font-bold text-center">Battle</h1>
      <div class="grid grid-cols-2 gap-2 mt-12">
        <.actor_card :for={actor <- @battle.actors} actor={actor} />
      </div>
      <div class="flex flex-col-reverse overflow-y-scroll h-96 mt-12 p-4">
        <div class="flex flex-col gap-2">
          <.turn_card :for={turn <- Enum.sort_by(@battle.turns, & &1.number)} turn={turn} />
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: send(self(), :tick),
      else: nil

    {:ok, assign(socket, :battle, nil)}
  end

  def handle_info(:tick, socket) do
    battle = socket.assigns.battle || GEMS.Engine.Battler.seed()

    if battle.status == :running do
      battle = GEMS.Engine.Battler.Battle.next(battle)
      Process.send_after(self(), :tick, 500)
      {:noreply, assign(socket, :battle, battle)}
    else
      {:noreply, assign(socket, :battle, battle)}
    end
  end

  attr :actor, GEMS.Engine.Battler.Actor, required: true

  defp actor_card(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <img src="https://placehold.co/100" class="rounded" />
      <div class="flex flex-col space-y-2 gap-1 w-full">
        <span class={["font-medium", actor_text_color_class(@actor)]}>
          <%= @actor.__id__ %>
        </span>
        <div class="flex flex-col gap-1">
          <.progress
            id={@actor.__id__}
            value={@actor.__health__}
            max_value={@actor.max_health}
            variant="health"
          />
          <.progress
            id={@actor.__id__}
            value={@actor.__energy__}
            max_value={@actor.max_energy}
            variant="energy"
          />
        </div>
      </div>
    </div>
    """
  end

  attr :turn, GEMS.Engine.Battler.Turn, required: true

  defp turn_card(assigns) do
    ~H"""
    <div class={[
      "flex flex-col gap-2 rounded bg-gray-100 shadow p-2 border-2",
      actor_border_color_class(@turn.leader)
    ]}>
      <div class="flex gap-2">
        <span class="flex items-center justify-center font-medium size-6 rounded-full bg-gray-800 text-gray-100">
          <%= @turn.number %>
        </span>
        <span class="font-medium">
          <%= @turn.leader.__id__ %>
        </span>
      </div>
      <div :for={event <- @turn.events} class="flex flex-col">
        <.event_card event={event} />
      </div>
    </div>
    """
  end

  attr :event, GEMS.Engine.Battler.Event, required: true

  defp event_card(assigns) do
    ~H"""
    <div class="bg-gradient-to-r from-gray-200 to-gray-400 rounded py-1 px-2">
      <%= inspect(@event) %>
    </div>
    """
  end

  defp actor_text_color_class(%{__party__: :red}), do: "text-red-500"
  defp actor_text_color_class(%{__party__: :blue}), do: "text-blue-500"
  defp actor_border_color_class(%{__party__: :red}), do: "border-red-500"
  defp actor_border_color_class(%{__party__: :blue}), do: "border-blue-500"

  attr :id, :string, required: true
  attr :value, :integer, required: true
  attr :max_value, :integer, required: true
  attr :variant, :string, required: true

  defp progress(assigns) do
    assigns = assign_new(assigns, :percentage, &round(&1.value / &1.max_value * 100))

    assigns =
      assign_new(assigns, :progress_classes, fn
        %{variant: "health"} -> "from-red-700 via-red-500 to-red-500"
        %{variant: "energy"} -> "from-purple-700 via-purple-500 to-purple-500"
      end)

    ~H"""
    <div
      class="flex w-full h-2 bg-gray-200 rounded-full overflow-hidden"
      title={"#{@percentage}% (#{@value} / #{@max_value})"}
    >
      <div
        class={[
          "flex flex-col justify-center rounded-full overflow-hidden bg-gradient-to-r",
          @progress_classes
        ]}
        style={"width: #{@percentage}%"}
      >
      </div>
    </div>
    """
  end
end
