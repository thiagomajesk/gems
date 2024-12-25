defmodule GEMSWeb.Game.ActivitiesLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    activities = GEMS.World.list_available_activities(character)
    activity_lookup = Map.new(activities, &{&1.id, &1})

    if connected?(socket), do: GEMS.ActivityManager.subscribe(character)

    {:ok,
     assign(socket,
       activities: activities,
       activity_lookup: activity_lookup,
       selected_activity: nil
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4">
      <.activity_card
        :for={activity <- @activities}
        activity={activity}
        active={activity.id == get_in(@selected_activity.id)}
      />
    </div>
    """
  end

  attr :activity, :any, required: true
  attr :active, :boolean, default: false

  defp activity_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <div class="flex items-center gap-2">
        <img src="https://placehold.co/80" class="size-18 rounded-xl" />
        <div class="flex flex-col justify-between space-y-2 grow">
          <div class="flex items-center">
            <span class="font-semibold w-1/2">{@activity.item.name}</span>
            <div class="flex items-center justify-end w-1/2 gap-2">
              <span class="badge badge-accent font-medium">{@activity.profession.name}</span>
              <button
                :if={!@active}
                class="btn btn-neutral btn-sm grow max-w-32"
                phx-click="start"
                phx-value-id={@activity.id}
              >
                {@activity.action}
              </button>
              <button
                :if={@active}
                class="btn btn-neutral btn-sm grow max-w-32"
                phx-click="stop"
                phx-value-id={@activity.id}
              >
                <UI.Icons.page name="circle-stop" /> Stop
              </button>
            </div>
          </div>
          <div class="flex items-center justify-between mt-1">
            <div class="flex items-center gap-2">
              <span class="badge badge-neutral font-medium">
                {"LV #{@activity.required_level}"}
              </span>
            </div>
            <div class="flex items-center gap-2">
              <span class="badge badge-neutral font-medium gap-1">
                <UI.Icons.page name="clock" />
                <span>{"#{@activity.duration}s"}</span>
              </span>
              <span class="badge badge-neutral font-medium gap-1">
                {"#{@activity.experience} EXP"}
              </span>
            </div>
          </div>
          <progress class="progress" value="40" max="100"></progress>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("start", %{"id" => activity_id}, socket) do
    character = socket.assigns.selected_character

    activity_lookup = socket.assigns.activity_lookup
    activity = Map.fetch!(activity_lookup, activity_id)

    GEMS.ActivityManager.start_activity(character, activity)

    # Optimistic update the assign before we get notified by the server
    {:noreply, assign(socket, selected_activity: activity)}
  end

  @impl true
  def handle_info({:activity_started, activity}, socket) do
    Logger.debug("STARTED ACTIVITY: #{activity.id}, #{inspect(self())}")
    {:noreply, assign(socket, selected_activity: activity)}
  end

  @impl true
  def handle_info({:activity_stopped, activity}, socket) do
    Logger.debug("STOPPED ACTIVITY: #{activity.id}, #{inspect(self())}")
    {:noreply, assign(socket, selected_activity: nil)}
  end
end
