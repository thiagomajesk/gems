defmodule GEMSWeb.CharacterLive.New do
  use GEMSWeb, :live_view

  alias GEMS.Characters
  alias GEMS.World.Schema.Character
  alias GEMSWeb.CharacterLive.AttributeAllocatorComponent
  alias GEMSWeb.CharacterLive.AvatarSelectorComponent

  def mount(_params, _session, socket) do
    changeset = Characters.change_character(%Character{})
    faction_options = GEMS.World.Schema.Faction.options()

    {:ok, assign(socket, form: to_form(changeset), faction_options: faction_options)}
  end

  def render(assigns) do
    ~H"""
    <section class="container mx-auto py-8">
      <h1 class="text-3xl font-semibold mb-4">New character</h1>
      <.form
        :let={f}
        id="character-creation-form"
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

        <section class="flex flex-col card bg-base-300 p-4">
          <h2 class="text-lg text-center font-semibold mb-4">Attributes</h2>
          <.live_component form={f} id="attribute-allocator" module={AttributeAllocatorComponent} />
        </section>

        <section class="flex flex-col card bg-base-300 p-4">
          <h2 class="text-lg text-center font-semibold mb-4">Avatars</h2>
          <.live_component
            field={f[:avatar_id]}
            id="avatar-selector"
            module={AvatarSelectorComponent}
          />
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

  def handle_info({AttributeAllocatorComponent, :validate, attributes}, socket) do
    %{form: %{data: character, params: params}} = socket.assigns
    changeset = Characters.change_character(character, Map.merge(params, attributes))
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_info({AvatarSelectorComponent, :validate, avatar_id}, socket) do
    %{form: %{data: character, params: params}} = socket.assigns
    updated_params = Map.merge(params, %{"avatar_id" => avatar_id})
    changeset = Characters.change_character(character, updated_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end
end
