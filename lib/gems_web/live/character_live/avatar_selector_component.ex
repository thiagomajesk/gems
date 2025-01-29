defmodule GEMSWeb.CharacterLive.AvatarSelectorComponent do
  use GEMSWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <div role="alert" class="alert bg-base-content/5">
        <UI.Icons.page :if={@errors == []} name="circle-alert" class="text-info" size={18} />
        <UI.Icons.page :if={@errors != []} name="circle-alert" class="text-error" size={18} />
        <div class="flex flex-col">
          <strong>Choose your avatar (you can change later)</strong>
          <p :if={@errors == []}>Your avatar is how people will recognize you in the game</p>
          <span :if={@errors != []} class="text-error">{@errors}</span>
        </div>
      </div>
      <div class="grid grid-cols-4 md:grid-cols-8 gap-4">
        <.input type="hidden" field={@field} value={@value || @selected} />
        <UI.Media.avatar
          :for={avatar <- @avatars}
          avatar={avatar}
          phx-click="select"
          phx-target={@myself}
          phx-value-id={avatar.id}
          data-selected={@selected == avatar.id}
          class={[
            "rounded-btn overflow-hidden border-2",
            "border-transparent hover:border-primary cursor-pointer",
            "data-[selected]:border-primary"
          ]}
        />
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    avatars = GEMS.World.list_avatars()
    {:ok, assign(socket, avatars: avatars, selected: nil)}
  end

  @impl true
  def update(assigns, socket) do
    assigns = fetch_assigns(assigns, [:id, :field])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_input_state(assigns.field)}
  end

  @impl true
  def handle_event("select", %{"id" => avatar_id}, socket) do
    send(self(), {__MODULE__, :validate, avatar_id})

    {:noreply, assign(socket, selected: avatar_id)}
  end
end
