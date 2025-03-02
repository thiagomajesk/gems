defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.IconPickerComponent do
  use GEMSWeb, :live_component

  alias GEMSWeb.Admin.Database.CollectionLive.Forms.SharedInputs

  @max_icons 100

  @impl true
  def render(assigns) do
    ~H"""
    <fieldset id={"#{@id}-icon-picker"} class="fieldset" phx-hook="IconPicker">
      <label class="label">{@label}</label>
      <.inputs_for :let={f} field={@field}>
        <div class="input w-full flex items-center px-2">
          <div :if={@value} class="flex items-center gap-2">
            <SharedInputs.colorpicker field={f[:color]} phx-debounce="10" />
            <UI.Icons.game
              name={f[:name].value}
              class="text-4xl"
              style={"color: #{f[:color].value}"}
              noobserver
            />
            <SharedInputs.unstyled
              type="text"
              field={f[:name]}
              class="ml-2 text-neutral grow"
              readonly
            />
          </div>

          <button
            type="button"
            class="btn btn-sm ml-auto"
            phx-target={@myself}
            phx-click="toggle-icon-picker"
          >
            <UI.Icons.page name="file-stack" /> Select
          </button>
        </div>
        <.icon_picker icons={@streams[:icons]} open={@picker_open} search={@search} target={@myself} />
      </.inputs_for>
    </fieldset>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:search, "")
     |> assign(picker_open: false)
     |> stream_configure(:icons, dom_id: & &1)}
  end

  @impl true
  def update(assigns, socket) do
    assigns = fetch_assigns(assigns, [:id, :field, :label])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_input_state(assigns.field, force: true)}
  end

  @impl true
  def handle_event("toggle-icon-picker", _params, socket) do
    open = socket.assigns.picker_open
    {:noreply, assign(socket, picker_open: !open)}
  end

  @impl true
  def handle_event("icon-picker:icons", %{"icons" => icons}, socket) do
    {:noreply,
     socket
     |> assign(:icons, icons)
     |> update_icon_stream()}
  end

  @impl true
  def handle_event("search-icon-picker", %{"value" => search}, socket) do
    {:noreply,
     socket
     |> assign(:search, search)
     |> update_icon_stream()}
  end

  @impl true
  def handle_event("select-icon", %{"icon" => icon}, socket) do
    send(self(), {__MODULE__, :validate, %{"icon" => %{name: icon}}})
    {:noreply, assign(socket, picker_open: false)}
  end

  attr :icons, :list, required: true
  attr :open, :boolean, required: true
  attr :search, :string, required: true
  attr :target, :any, required: true

  defp icon_picker(assigns) do
    ~H"""
    <div class="modal" role="dialog" open={@open}>
      <div class="modal-box flex flex-col border border-base-content/10 max-w-6xl overflow-y-hidden">
        <header class="text-neutral flex items-center bg-base-200 rounded-box gap-2 py-2 px-4 mb-4">
          <label class="input input-sm input-ghost bg-base-200 flex items-center gap-2 grow">
            <UI.Icons.page name="search" />
            <input
              type="text"
              class="grow"
              phx-target={@target}
              phx-keyup="search-icon-picker"
              placeholder="Search"
            />
          </label>
          <button
            type="button"
            class="btn btn-sm text-sm ml-auto"
            phx-target={@target}
            phx-click="toggle-icon-picker"
          >
            <UI.Icons.page name="x" />
          </button>
        </header>
        <ul
          id="icon-picker-list"
          phx-update="stream"
          class="grid grid-cols-3 md:grid-cols-6 lg:grid-cols-8 gap-2 overflow-y-auto px-1"
        >
          <li
            :for={{dom_id, icon} <- @icons || []}
            id={dom_id}
            class="hover:text-primary cursor-pointer data-selected:text-primary"
            title={icon}
          >
            <span
              phx-target={@target}
              phx-click="select-icon"
              phx-value-icon={icon}
              class="flex flex-col items-center hover:bg-base-200 rounded-box p-2"
            >
              <UI.Icons.game name={icon} class="text-4xl" noobserver />
              <.search_mark icon={icon} search={@search} />
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  defp update_icon_stream(socket) do
    %{icons: icons, search: search} = socket.assigns

    sorted =
      icons
      |> sort_icons(search)
      |> Enum.take(@max_icons)
      |> Enum.reverse()

    stream(socket, :icons, sorted, reset: true, at: 0, limit: @max_icons)
  end

  def sort_icons(icons, ""), do: Enum.sort(icons)

  def sort_icons(icons, search),
    do: Enum.sort_by(icons, &String.jaro_distance(&1, search), :desc)

  attr :icon, :string, required: true
  attr :search, :string, required: true

  defp search_mark(assigns) do
    ~H"""
    <span class="text-xs text-neutral">
      <%= case String.split(@icon, @search, parts: 2) do %>
        <% ["", rest] -> %>
          <mark class="bg-transparent text-primary">{@search}</mark>
          <span class="-ml-[3px]">{rest}</span>
        <% icon -> %>
          <span>{icon}</span>
      <% end %>
    </span>
    """
  end
end
