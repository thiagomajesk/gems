defmodule GEMSWeb.CharacterLive.PreviewSelectorComponent do
  use GEMSWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <div role="alert" class="alert bg-base-200 border border-base-content/10">
        <UI.Icons.page :if={@errors == []} name="circle-alert" class="text-info" size={18} />
        <UI.Icons.page :if={@errors != []} name="circle-alert" class="text-error" size={18} />
        <div class="flex flex-col">
          <span class="font-medium">{@title}</span>
          <span :if={@errors == []} class="text-sm">{@subtitle}</span>
          <span :if={@errors != []} class="text-error">{@errors}</span>
        </div>
      </div>
      <div class="grid grid-cols-4 md:grid-cols-6 xl:grid-cols-8 gap-4">
        <.input type="hidden" field={@field} value={@value || @selected} />
        <div
          :for={item <- @item}
          phx-click="select"
          phx-target={@myself}
          phx-value-id={Map.fetch!(item, :id)}
          data-selected={@selected == Map.fetch!(item, :id)}
          class={[
            "rounded-lg overflow-hidden bg-base-content/5 p-1 shadow",
            "border-2 border-transparent hover:border-primary cursor-pointer",
            "transition-all duration-200 transform hover:-translate-y-0.5 hover:shadow",
            "data-selected:border-primary"
          ]}
        >
          {render_slot(item)}
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, items: [], selected: nil)}
  end

  @impl true
  def update(assigns, socket) do
    assigns = fetch_assigns(assigns, [:id, :field, :title, :subtitle, :item])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_input_state(assigns.field)}
  end

  @impl true
  def handle_event("select", %{"id" => selected}, socket) do
    field_name = to_string(get_in(socket.assigns.field.field))
    send(self(), {__MODULE__, :validate, %{field_name => selected}})
    {:noreply, assign(socket, selected: selected)}
  end
end
