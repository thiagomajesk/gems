defmodule GEMSWeb.CharacterLive.Index do
  use GEMSWeb, :live_view

  alias GEMS.Characters

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-8">
      <UI.Panels.container tag="section">
        <header class="flex items-center justify-between">
          <h1 class="mb-4 text-3xl font-semibold">Characters</h1>
          <a href={~p"/accounts/characters/new"} class="btn btn-primary">
            <UI.Icons.page name="plus-circle" size={18} /> New character
          </a>
        </header>
        <div class="grid grid-cols-2 md:grid-cols-4 xl:grid-cols-6 gap-4 mt-8">
          <.link
            :for={character <- @characters}
            href={~p"/character/#{character}/select"}
            draggable="false"
            method="post"
            class={[
              "card bg-base-300 p-4 shadow border border-base-content/10",
              "transition-all duration-200 hover:scale-105 hover:shadow-lg hover:shadow-primary/20 hover:border-primary"
            ]}
          >
            <UI.Media.avatar avatar={character.avatar} class="rounded-lg" />
            <div class="flex flex-col items-center justify-center grow space-y-2 mt-2">
              <span class="font-medium">{character.name}</span>
              <span class="badge badge-neutral gap-2 font-medium">
                <span>{character.class.name}</span>
                {"LV #{character.level}"}
              </span>
            </div>
          </.link>
        </div>
      </UI.Panels.container>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, assign(socket, :characters, Characters.list_characters(user))}
  end
end
