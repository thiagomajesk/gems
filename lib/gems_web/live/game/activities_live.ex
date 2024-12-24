defmodule GEMSWeb.Game.ActivitiesLive do
  use GEMSWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    activities = GEMS.World.list_activities_for(character)
    {:ok, assign(socket, :activities, activities)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4">
      <.activity_card :for={activity <- @activities} activity={activity} />
    </div>
    """
  end

  attr :activity, :any, required: true

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
              <button class="btn btn-neutral btn-sm grow max-w-32">{@activity.action}</button>
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
end
