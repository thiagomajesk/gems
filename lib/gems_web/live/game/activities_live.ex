defmodule GEMSWeb.Game.ActivitiesLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.live_component
        id="zone-preview"
        module={GEMSWeb.ZonePreviewComponent}
        zone_id={@selected_character.zone_id}
      />
      <UI.Panels.section title="Activities" divider>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <.activity_card
            :for={activity <- @activities}
            activity={activity}
            requirements={@activities_requirements[activity.id]}
            running_timer={
              if activity.id == @current_activity_id,
                do: @current_activity_timer
            }
          />
        </div>
      </UI.Panels.section>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    activities = GEMS.World.list_available_activities(character)
    activity_lookup = Map.new(activities, &{&1.id, &1})

    activity_metadata = GEMS.ActivityManager.fetch_state(character)

    if connected?(socket), do: GEMS.ActivityManager.subscribe(character)

    activities_requirements = activities_requirements_lookup(activities, character)

    {:ok,
     socket
     |> assign(:activities, activities)
     |> assign(:activity_lookup, activity_lookup)
     |> assign(:activities_requirements, activities_requirements)
     |> assign_current_activity_state(activity_metadata)}
  end

  @impl true
  def handle_event("start", %{"id" => activity_id}, socket) do
    character = socket.assigns.selected_character

    activity_lookup = socket.assigns.activity_lookup
    activity = Map.fetch!(activity_lookup, activity_id)

    GEMS.ActivityManager.start_activity(character, activity)

    # Optimistically update the assign before we get notified by the server
    {:noreply, assign(socket, current_activity_id: activity_id)}
  end

  @impl true
  def handle_event("stop", %{"id" => activity_id}, socket) do
    character = socket.assigns.selected_character

    activity_lookup = socket.assigns.activity_lookup
    activity = Map.fetch!(activity_lookup, activity_id)

    GEMS.ActivityManager.stop_activity(character, activity)

    # Optimistically update the assign before we get notified by the server
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

  @impl true
  def handle_info({:activity_completed, activity_metadata}, socket) do
    %{activity: %{id: activity_id}, character: character} = activity_metadata

    Logger.debug("COMPLETED ACTIVITY: #{activity_id}, #{inspect(self())}")

    activity_notification = %{
      kind: :activity_completed,
      metadata: %{
        amount: activity_metadata.amount,
        item: activity_metadata.activity.item,
        experience: activity_metadata.activity.experience,
        profession: activity_metadata.activity.profession
      }
    }

    send_update(GEMSWeb.NotificationCenterComponent,
      id: "activity-notification-center",
      notification: activity_notification
    )

    {:noreply, assign(socket, :selected_character, character)}
  end

  attr :activity, :any, required: true
  attr :requirements, :map, default: %{}
  attr :running_timer, :any, default: nil

  defp activity_card(assigns) do
    ~H"""
    <div class="card card-side bg-base-300 shadow card-border border-base-content/5 ">
      <div class="card-body flex-row p-3">
        <figure class="w-32 aspect-square rounded-box">
          <UI.Media.image placeholder={%{width: 100, height: 100}} />
        </figure>
        <div class="flex flex-col space-y-2 grow">
          <div class="flex items-center">
            <span class="font-semibold grow text-normal md:text-lg">{@activity.item.name}</span>
            <%= if @running_timer do %>
              <button
                class="btn btn-neutral btn-sm md:btn-md grow max-w-32"
                phx-click="stop"
                phx-value-id={@activity.id}
              >
                <UI.Icons.page name="circle-stop" class="text-[1.2em] text-error" /> Stop
              </button>
            <% else %>
              <button
                class="btn btn-neutral btn-sm md:btn-md grow max-w-32"
                phx-click={@requirements.satisfied_all? && "start"}
                phx-value-id={@requirements.satisfied_all? && @activity.id}
                disabled={!@requirements.satisfied_all?}
              >
                <UI.Icons.page name="circle-play" class="text-[1.2em] text-success" />
                <span>{Recase.to_title(@activity.action)}</span>
              </button>
            <% end %>
          </div>
          <p class="line-clamp-2 text-sm text-base-content/70 break-all">
            {@activity.item.description}
          </p>
          <div class="flex items-center flex-wrap gap-2">
            <span
              class="badge badge-sm md:badge-md badge-soft badge-accent font-medium gap-1"
              title="Profession"
            >
              <UI.Media.game_icon icon={@activity.profession.icon} class="text-[1.2em]" />
              <span>{@activity.profession.name}</span>
            </span>
            <span
              class={[
                "badge badge-sm md:badge-md font-medium",
                (@requirements.profession.satisfied? && "bg-base-content/5 border-base-content/5") ||
                  "badge-error"
              ]}
              title="Required level"
            >
              {"LV #{@activity.required_level}"}
            </span>
            <span
              class="badge badge-sm md:badge-md bg-base-content/5 border-base-content/5 font-medium gap-1"
              title="Duration"
            >
              <UI.Icons.page name="clock" class="text-[1.2em]" />
              <span>{"#{@activity.duration}s"}</span>
            </span>
            <span
              class="badge badge-sm md:badge-md bg-base-content/5 border-base-content/5 font-medium gap-1"
              title="Experience"
            >
              <UI.Icons.page name="arrow-big-up-dash" class="text-[1.2em]" />
              <span>{"#{@activity.experience} XP"}</span>
            </span>
          </div>
          <div class="flex items-center gap-2">
            <%= for item_ingredient <- @activity.item.item_ingredients do %>
              <% requirement = @requirements.ingredients[item_ingredient.ingredient.id] %>
              <span class={[
                "badge badge-sm md:badge-md font-medium gap-1",
                (requirement.satisfied? && "bg-base-content/5 border-base-content/5") || "badge-error"
              ]}>
                {"#{item_ingredient.amount}x #{item_ingredient.ingredient.name}"}
              </span>
            <% end %>
          </div>
          <UI.Progress.activity activity={@activity} timer={@running_timer} />
        </div>
      </div>
    </div>
    """
  end

  defp assign_current_activity_state(socket, metadata) do
    assign(socket,
      current_activity_id: get_in(metadata.activity.id),
      current_activity_timer: get_in(metadata.timer)
    )
  end

  defp activities_requirements_lookup(activities, character) do
    character_items_lookup = character_items_lookup(character)
    character_professions_lookup = character_professions_lookup(character)

    Map.new(activities, fn activity ->
      ingredient_requirements = ingredient_requirements(activity, character_items_lookup)
      profession_requirements = profession_requirements(activity, character_professions_lookup)

      {activity.id,
       %{
         satisfied_all?:
           profession_requirements.satisfied? &&
             Enum.all?(Map.values(ingredient_requirements), & &1.satisfied?),
         profession: profession_requirements,
         ingredients: ingredient_requirements
       }}
    end)
  end

  defp character_items_lookup(character) do
    character
    |> GEMS.Characters.list_character_items()
    |> Map.new(&{&1.item_id, &1.amount})
  end

  defp character_professions_lookup(character) do
    character
    |> GEMS.Characters.list_character_professions()
    |> Map.new(&{&1.profession_id, &1.level})
  end

  def profession_requirements(activity, lookup) do
    current_level = Map.get(lookup, activity.profession.id, 0)

    %{
      current_level: current_level,
      required_level: activity.required_level,
      satisfied?: current_level >= activity.required_level
    }
  end

  defp ingredient_requirements(activity, lookup) do
    Map.new(activity.item.item_ingredients, fn ingredient ->
      current_amount = Map.get(lookup, ingredient.ingredient.id, 0)

      {ingredient.ingredient_id,
       %{
         current_amount: current_amount,
         amount: ingredient.amount,
         satisfied?: current_amount >= ingredient.amount
       }}
    end)
  end
end
