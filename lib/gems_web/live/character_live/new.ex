defmodule GEMSWeb.CharacterLive.New do
  use GEMSWeb, :live_view

  alias GEMS.Characters
  alias GEMS.Engine.Schema.Character

  def mount(_params, _session, socket) do
    avatars = GEMS.World.list_avatars()
    changeset = Characters.change_character(%Character{})
    faction_options = GEMS.World.Schema.Faction.options()

    {:ok,
     assign(socket,
       form: to_form(changeset),
       avatars: avatars,
       faction_options: faction_options
     )}
  end

  def render(assigns) do
    ~H"""
    <section class="container mx-auto py-8">
      <h1 class="text-3xl font-semibold mb-4">New character</h1>
      <.form
        :let={f}
        for={@form}
        phx-submit="save"
        phx-change="validate"
        class="card bg-base-200 p-4 space-y-4 shadow"
      >
        <.input type="text" field={f[:name]} label="Name" required />
        <.input
          type="select"
          field={f[:faction_id]}
          label="Faction"
          options={@faction_options}
          required
        />
        <section class="flex flex-col">
          <h2 class="text-lg text-center font-semibold mb-4">Avatars</h2>
          <div class="grid grid-cols-4 md:grid-cols-8 gap-4">
            <.inputs_for_avatar avatars={@avatars} field={f[:avatar_id]} />
          </div>
        </section>
        <div>
          <button type="submit" class="btn btn-primary">Create character</button>
        </div>
      </.form>
    </section>
    """
  end

  def handle_event("validate", %{"character" => params}, socket) do
    %{form: %{data: character}} = socket.assigns
    changeset = Characters.change_character(character, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"character" => params}, socket) do
    user = socket.assigns.current_user

    case Characters.create_character(user, params) do
      {:ok, _character} ->
        {:noreply, push_navigate(socket, to: ~p"/accounts/characters")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :avatars, :list, required: true

  defp inputs_for_avatar(assigns) do
    ~H"""
    <div :for={{avatar, idx} <- Enum.with_index(@avatars)}>
      <label phx-click={JS.dispatch("change")} for={"#{@field.id}_#{idx}"}>
        <.avatar avatar={avatar} selected={@field.value == avatar.id} />
        <input
          type="radio"
          name={@field.name}
          id={"#{@field.id}_#{idx}"}
          value={avatar.id}
          checked={@field.value == avatar.id}
          class="hidden"
        />
      </label>
    </div>
    """
  end

  attr :avatar, :map, required: true
  attr :selected, :boolean, default: false

  defp avatar(assigns) do
    assigns =
      assign_new(assigns, :src, fn %{avatar: avatar} ->
        avatar_path = ["avatars", avatar.icon]
        system_path = GEMSData.GameInfo.asset_path(avatar_path)
        Path.join(GEMSWeb.Endpoint.url(), system_path)
      end)

    ~H"""
    <img
      src={@src}
      data-selected={@selected}
      class={[
        "rounded-btn overflow-hidden border-2",
        "border-transparent hover:border-primary cursor-pointer",
        "data-[selected]:border-primary"
      ]}
    />
    """
  end
end
