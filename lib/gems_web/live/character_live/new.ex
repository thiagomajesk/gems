defmodule GEMSWeb.CharacterLive.New do
  use GEMSWeb, :live_view

  alias GEMS.Characters
  alias GEMS.World.Schema.Character
  alias GEMSWeb.CharacterLive.PreviewSelectorComponent

  def render(assigns) do
    ~H"""
    <div class="py-8">
      <UI.Panels.container tag="section" title="New character">
        <header class="flex items-center justify-between">
          <h1 class="mb-4 text-3xl font-semibold">New Character</h1>
        </header>
        <.form
          :let={f}
          id="character-creation-form"
          for={@form}
          phx-submit="save"
          phx-change="validate"
          class="card bg-base-300 p-4 space-y-4 border border-base-content/10 shadow"
        >
          <.input type="text" field={f[:name]} label="Name" required />
          <.input type="select" field={f[:class_id]} label="Class" options={@class_options} required />
          <.input
            type="select"
            field={f[:faction_id]}
            label="Faction"
            options={@faction_options}
            required
          />

          <UI.Panels.section title="Avatars" center>
            <.live_component
              field={f[:avatar_id]}
              id="avatar-selector"
              title="Choose your character's avatar"
              subtitle="This will determine your character's in-game appearance"
              module={PreviewSelectorComponent}
            >
              <:item :for={avatar <- @avatars} id={avatar.id}>
                <UI.Media.avatar avatar={avatar} />
              </:item>
            </.live_component>
          </UI.Panels.section>
          <div>
            <button type="submit" class="btn btn-primary">Create character</button>
          </div>
        </.form>
      </UI.Panels.container>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Characters.change_character(%Character{})
    class_options = GEMS.Engine.Schema.Class.options()
    faction_options = GEMS.World.Schema.Faction.options()

    avatars = GEMS.World.list_avatars()

    {:ok,
     assign(socket,
       form: to_form(changeset),
       class_options: class_options,
       faction_options: faction_options,
       avatars: avatars
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
