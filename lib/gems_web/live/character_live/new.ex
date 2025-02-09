defmodule GEMSWeb.CharacterLive.New do
  use GEMSWeb, :live_view

  alias GEMS.Characters
  alias GEMS.World.Schema.Character
  alias GEMSWeb.CharacterLive.PreviewSelectorComponent

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
          <h2 class="text-lg text-center font-semibold mb-4">Origins</h2>
          <.live_component
            field={f[:origin_id]}
            title="Choose your character's origin"
            subtitle="This will determine your character's starting attributes"
            id="origin-selector"
            module={PreviewSelectorComponent}
          >
            <:preview :let={origin}>{inspect(origin)}</:preview>
            <:item :for={origin <- @origins} id={origin.id}>
              <UI.Media.origin origin={origin} />
            </:item>
          </.live_component>
        </section>

        <section class="flex flex-col card bg-base-300 p-4">
          <h2 class="text-lg text-center font-semibold mb-4">Avatars</h2>
          <.live_component
            field={f[:avatar_id]}
            id="avatar-selector"
            title="Choose your character's avatar"
            subtitle="This will determine your character's in-game appearance"
            module={PreviewSelectorComponent}
          >
            <:preview :let={avatar}>{inspect(avatar)}</:preview>
            <:item :for={avatar <- @avatars} id={avatar.id}>
              <UI.Media.avatar avatar={avatar} />
            </:item>
          </.live_component>
        </section>
        <div>
          <button type="submit" class="btn btn-primary">Create character</button>
        </div>
      </.form>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Characters.change_character(%Character{})
    faction_options = GEMS.World.Schema.Faction.options()

    origins = GEMS.World.list_origins()
    avatars = GEMS.World.list_avatars()

    {:ok,
     assign(socket,
       form: to_form(changeset),
       faction_options: faction_options,
       avatars: avatars,
       origins: origins
     )}
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

  def handle_info({PreviewSelectorComponent, :validate, merge_params}, socket) do
    %{form: %{data: character, params: params}} = socket.assigns
    updated_params = Map.merge(params, Map.merge(params, merge_params))
    changeset = Characters.change_character(character, updated_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end
end
