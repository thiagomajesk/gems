defmodule GEMSWeb.NotificationCenterComponent do
  use GEMSWeb, :live_component

  def render(assigns) do
    assigns =
      assign_new(assigns, :activity_completed_notifications, fn assigns ->
        Enum.filter(assigns.notifications, &(&1.kind == :activity_completed))
      end)

    ~H"""
    <div class="fixed bottom-2 z-999 space-y-2 w-full bg-gradient-to-b from-transparent to-base-300 group">
      <div class="w-56 mx-auto space-y-2">
        <.activity_completed
          :for={notification <- @activity_completed_notifications}
          {assigns_to_attributes(notification.metadata)}
        />
      </div>
    </div>
    """
  end

  def mount(assigns) do
    {:ok, assign(assigns, notifications: [])}
  end

  def update(%{notification: notification}, socket) do
    id = System.unique_integer([:positive])
    notification = Map.put(notification, :id, id)
    send_update_after(socket.assigns.myself, [expired: notification.id], 5000)
    {:ok, update(socket, :notifications, &[notification | &1])}
  end

  def update(%{expired: notification_id}, socket) do
    {:ok,
     update(socket, :notifications, fn notifications ->
       Enum.reject(notifications, &(&1.id == notification_id))
     end)}
  end

  def update(assigns, socket), do: {:ok, assign(socket, assigns)}

  attr :amount, :integer, required: true
  attr :item, :map, required: true
  attr :experience, :integer, required: true
  attr :profession, :map, required: true

  defp activity_completed(assigns) do
    ~H"""
    <div
      role="alert"
      phx-mounted={show()}
      phx-remove={hide()}
      class={[
        "p-0.5 rounded-box shadow shadow-emerald-300/50 animate-shine grow",
        "group-hover:rotate-4 group-hover:translate-x-2 group-hover:-translate-y-1/2",
        "bg-gradient-to-tr from-emerald-300/80 via-cyan-300/80 to-fuchsia-300/80 backdrop-blur",
        "transition-all duration-200 transform-gpu"
      ]}
    >
      <div class="flex items-center gap-2 rounded-box p-2 bg-gradient-to-b from-base-300/95 to-base-300/70 backdrop-blur">
        <UI.Media.image placeholder={%{height: 50, width: 50}} class="rounded-box" />
        <div class="flex flex-col grow justify-between space-y-1">
          <div class="flex items-center gap-2">
            <span class="text-2xl font-black">{@amount}</span>
            <span class="font-medium">{@item.name}</span>
          </div>
          <div class="flex items-center gap-1 animate-pulse">
            <UI.Media.game_icon icon={@profession.icon} />
            <span class="text-xs font-medium">{"+#{@experience} XP in #{@profession.name}"}</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp show() do
    JS.transition({"ease-in-expo", "opacity-0 scale-0", "opacity-100 scale-100"}, time: 1000)
  end

  defp hide() do
    JS.transition({"ease-out-expo", "opacity-100 scale-100", "opacity-0 scale-0"}, time: 1000)
  end
end
