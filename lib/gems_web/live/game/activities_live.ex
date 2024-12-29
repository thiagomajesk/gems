defmodule GEMSWeb.Game.ActivitiesLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    activities = GEMS.World.list_available_activities(character)
    activity_lookup = Map.new(activities, &{&1.id, &1})

    activity_metadata = GEMS.ActivityManager.fetch_state(character)

    if connected?(socket), do: GEMS.ActivityManager.subscribe(character)

    character_items_lookup =
      character
      |> GEMS.Characters.list_character_items()
      |> Map.new(&{&1.item_id, &1.amount})

    character_professions_lookup =
      character
      |> GEMS.Characters.list_character_professions()
      |> Map.new(&{&1.profession_id, &1.level})

    {:ok,
     socket
     |> assign(:activities, activities)
     |> assign(:activity_lookup, activity_lookup)
     |> assign(:character_items_lookup, character_items_lookup)
     |> assign(:character_professions_lookup, character_professions_lookup)
     |> assign_current_activity_state(activity_metadata)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
      <.activity_card
        :for={activity <- @activities}
        activity={activity}
        satisfies_level={satisfies_level?(activity, @character_professions_lookup)}
        satisfied_ingredients={satisfied_ingredients(activity, @character_items_lookup)}
        running_timer={
          if activity.id == @current_activity_id,
            do: @current_activity_timer
        }
      />
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
    {:noreply, assign(socket, current_activity_id: activity_id)}
  end

  @impl true
  def handle_event("stop", %{"id" => activity_id}, socket) do
    character = socket.assigns.selected_character

    activity_lookup = socket.assigns.activity_lookup
    activity = Map.fetch!(activity_lookup, activity_id)

    GEMS.ActivityManager.stop_activity(character, activity)

    # Optimistic update the assign before we get notified by the server
    {:noreply, assign(socket, current_activity_id: nil)}
  end

  @impl true
  def handle_info({:activity_started, activity_metadata}, socket) do
    %{activity: %{id: activity_id}} = activity_metadata
    Logger.debug("STARTED ACTIVITY: #{activity_id}, #{inspect(self())}")
    {:noreply, assign_current_activity_state(socket, activity_metadata)}
  end

  @impl true
  def handle_info({:activity_stopped, activity_metadata}, socket) do
    %{activity: %{id: activity_id}} = activity_metadata
    Logger.debug("STOPPED ACTIVITY: #{activity_id}, #{inspect(self())}")
    {:noreply, assign_current_activity_state(socket, nil)}
  end

  attr :activity, :any, required: true
  attr :satisfies_level, :boolean, default: false
  attr :satisfied_ingredients, :map, default: %{}
  attr :running_timer, :any, default: nil

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
                :if={!@running_timer}
                class="btn btn-neutral btn-sm grow max-w-32"
                phx-click="start"
                phx-value-id={@activity.id}
              >
                {@activity.action}
              </button>
              <button
                :if={@running_timer}
                class="btn btn-neutral btn-sm grow max-w-32"
                phx-click="stop"
                phx-value-id={@activity.id}
              >
                <UI.Icons.page name="circle-stop" /> Stop
              </button>
            </div>
          </div>
          <div class="flex items-center justify-between flex-wrap gap-1 mt-1">
            <div class="flex items-center gap-2">
              <span class={[
                "badge font-medium",
                (@satisfies_level && "badge-neutral") || "badge-error"
              ]}>
                {"LV #{@activity.level_required}"}
              </span>
              <span class="badge badge-neutral font-medium gap-1">
                <UI.Icons.page name="clock" />
                <span>{"#{@activity.duration}s"}</span>
              </span>
              <span class="badge badge-neutral font-medium gap-1">
                {"#{@activity.experience} XP"}
              </span>
            </div>
            <div class="flex items-center gap-2">
              <span
                :for={ingredient <- @activity.item.item_ingredients}
                class={[
                  "badge font-medium gap-1",
                  (@satisfied_ingredients[ingredient.ingredient.id] && "badge-neutral") ||
                    "badge-error"
                ]}
              >
                {"#{ingredient.amount}x #{ingredient.ingredient.name}"}
              </span>
            </div>
          </div>
          <.activity_progress
            id={"#{@activity.id}-progress"}
            animate={@running_timer != nil}
            duration={:timer.seconds(@activity.duration)}
            remaining={
              if @running_timer,
                do: Process.read_timer(@running_timer) || 0,
                else: :timer.seconds(@activity.duration)
            }
          />
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :animate, :boolean, default: false
  attr :duration, :integer, required: true
  attr :remaining, :integer, required: true

  defp activity_progress(assigns) do
    assigns =
      assigns
      |> assign_new(:value, &(&1.duration - &1.remaining))
      |> assign_props(&%{animate: &1.animate})

    ~H"""
    <progress
      id={@id}
      max={@duration}
      value={@value}
      class="progress"
      phx-hook="ActivityProgress"
      data-props={@props}
    >
    </progress>
    """
  end

  defp assign_current_activity_state(socket, metadata) do
    assign(socket,
      current_activity_id: get_in(metadata.activity.id),
      current_activity_timer: get_in(metadata.timer)
    )
  end

  defp satisfies_level?(activity, lookup) do
    current_level = Map.get(lookup, activity.profession.id, 0)
    current_level >= activity.level_required
  end

  defp satisfied_ingredients(activity, lookup) do
    Map.new(activity.item.item_ingredients, fn ingredient ->
      current_amount = Map.get(lookup, ingredient.ingredient.id, 0)
      {ingredient.item_id, current_amount >= ingredient.amount}
    end)
  end
end
