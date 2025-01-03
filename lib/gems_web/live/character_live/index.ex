defmodule GEMSWeb.CharacterLive.Index do
  use GEMSWeb, :live_view

  alias GEMS.Characters

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, assign(socket, :characters, Characters.list_characters(user))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="container mx-auto py-8">
      <header class="flex items-center justify-between">
        <h1 class="mb-4 text-3xl font-semibold">Character Creation</h1>
        <a href={~p"/accounts/characters/new"} class="btn btn-primary">
          <UI.Icons.page name="plus-circle" size={18} /> Create character
        </a>
      </header>
      <div class="grid grid-cols-3 gap-4 mt-8">
        <div :for={character <- @characters} class="card bg-base-content/5 p-4 shadow">
          <div class="flex justify-between gap-4">
            <UI.Media.avatar avatar={character.avatar} class="size-24 rounded-lg" />
            <div class="flex flex-col items-center grow space-y-2">
              <span class="text-center font-medium">{character.name}</span>
              <span :if={character.title} class="text-xs text-center">{character.title}</span>
              <span class="badge badge-neutral font-medium gap-2">
                <UI.Icons.page name="zap" size={18} /> 1200 power
              </span>
              <.link
                href={~p"/character/#{character}/select"}
                method="post"
                class="btn btn-sm btn-accent w-full"
              >
                <UI.Icons.page name="play" size={18} /> Play
              </.link>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
