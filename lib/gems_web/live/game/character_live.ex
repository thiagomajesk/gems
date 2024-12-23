defmodule GEMSWeb.Game.CharacterLive do
  use GEMSWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character

    guild = GEMS.Characters.get_character_guild(character)
    character_professions = GEMS.Characters.list_character_professions(character)

    {:ok, assign(socket, guild: guild, character_professions: character_professions)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex gap-4">
      <div class="w-1/3 flex flex-col space-y-4">
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Bio</h1>
          <.bio_card text={@selected_character.bio} />
        </section>
        <section :if={@guild}>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Guild</h1>
          <.guild_card guild={@guild} />
        </section>
      </div>
      <div class="w-2/3 flex flex-col space-y-4">
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Professions</h1>
          <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-2">
            <.profession_card
              :for={character_profession <- @character_professions}
              icon={character_profession.profession.icon}
              name={character_profession.profession.name}
              level={character_profession.level}
              exp={character_profession.exp}
            />
          </div>
        </section>
      </div>
    </div>
    """
  end

  attr :text, :string, default: nil

  def bio_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <p :if={@text} class="line-clamp-6"></p>
      <div role="alert" class="alert bg-base-100 text-xs">
        <UI.Media.icon name="info" />
        <p>This character hasn't written their bio yet</p>
      </div>
      <button :if={!@text} class="btn btn-sm btn-neutral mt-4">
        <UI.Media.icon name="pencil" /> Edit bio
      </button>
      <button :if={@text} class="btn btn-sm btn-neutral mt-4">
        <UI.Media.icon name="arrow-right" /> Read more
      </button>
    </div>
    """
  end

  def guild_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <div class="flex gap-2">
        <img src="https://placehold.co/80" class="size-16 rounded-xl" />
        <div class="flex flex-col justify-between grow">
          <div class="flex items-center justify-between">
            <span class="font-semibold">Guild name</span>
            <span class="badge badge-accent">LV. 199</span>
          </div>
          <progress class="progress" value="40" max="100"></progress>
          <div class="flex items-center justify-between mt-1">
            <span class="badge badge-neutral gap-1">
              <UI.Media.icon name="user-round-cog" /> Leader
            </span>
            <span class="badge badge-neutral gap-1">
              <UI.Media.icon name="users" /> 299 members
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :level, :integer, required: true
  attr :exp, :integer, required: true
  attr :icon, :string, default: nil

  defp profession_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <div class="flex gap-2">
        <img src={@icon || "https://placehold.co/80"} class="size-16 rounded-xl" />
        <div class="flex flex-col justify-between grow">
          <div class="flex items-center justify-between">
            <span class="font-semibold">{@name}</span>
            <span class="badge badge-accent font-medium">{@level}/99</span>
          </div>
          <progress class="progress progress-primary" value="70" max="100"></progress>
          <div class="flex items-center justify-between mt-1">
            <div class="badge badge-neutral font-medium">EXP {@exp} of 100</div>
            <div class="badge badge-neutral font-medium gap-1">
              <UI.Media.icon name="loader" /> 70%
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
