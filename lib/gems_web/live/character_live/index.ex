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
          <UI.Media.icon name="plus-circle" /> Create character
        </a>
      </header>
      <div class="grid grid-cols-3 gap-4">
        <div
          :for={character <- @characters}
          class="rounded-box flex flex-col bg-base-content/5 p-4 space-y-4"
        >
          <span class="mt-4 text-center font-medium text-neutral-500">{character.name}</span>
          <button type="button" class="btn btn-sm btn-accent mt-auto">
            <UI.Media.icon name="play" /> Play
          </button>
        </div>
      </div>
    </section>
    """
  end
end
