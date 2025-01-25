defmodule GEMSWeb.Game.CharacterLive do
  use GEMSWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character

    guild = GEMS.Characters.get_character_guild(character)
    character_professions = GEMS.Characters.list_character_professions(character, [:profession])

    {:ok, assign(socket, guild: guild, character_professions: character_professions)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col md:flex-row gap-4">
      <div class="w-full md:w-1/3 flex flex-col space-y-4">
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Bio</h1>
          <.bio_card text={@selected_character.bio} />
        </section>
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Attributes</h1>
          <div class="grid grid-cols-3 gap-2">
            <div class="rounded-box flex flex-col items-center justify-center bg-gradient-to-br from-base-300 h-24 to-rose-500/10 gap-2 p-2 relative">
              <UI.Icons.game
                name="biceps"
                size="unset"
                class="h-full w-full absolute inset-0 text-rose-500"
              />
              <span class="font-bold tabular-nums text-xl bg-base-300/50 backdrop-blur-sm px-2 py-1 rounded-btn shadow size-12 flex items-center justify-center">
                {@selected_character.strength}
              </span>
              <small class="absolute bottom-2 right-2 font-semibold uppercase">
                STR
              </small>
            </div>
            <div class="rounded-box flex flex-col items-center justify-center bg-gradient-to-br from-base-300 h-24 to-emerald-500/10 gap-2 p-2 relative">
              <UI.Icons.game
                name="sprint"
                size="unset"
                class="h-full w-full absolute inset-0 text-emerald-500"
              />
              <span class="font-bold tabular-nums text-xl bg-base-300/50 backdrop-blur-sm px-2 py-1 rounded-btn shadow size-12 flex items-center justify-center">
                {@selected_character.dexterity}
              </span>
              <small class="absolute bottom-2 right-2 font-semibold uppercase">
                DEX
              </small>
            </div>
            <div class="rounded-box flex flex-col items-center justify-center bg-gradient-to-br from-base-300 h-24 to-indigo-500/10 gap-2 p-2 relative">
              <UI.Icons.game
                name="brain"
                size="unset"
                class="h-full w-full absolute inset-0 text-indigo-500"
              />
              <span class="font-bold tabular-nums text-xl bg-base-300/50 backdrop-blur-sm px-2 py-1 rounded-btn shadow size-12 flex items-center justify-center">
                {@selected_character.intelligence}
              </span>
              <small class="absolute bottom-2 right-2 font-semibold uppercase">
                INT
              </small>
            </div>
          </div>
        </section>
        <section :if={@guild}>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Guild</h1>
          <.guild_card guild={@guild} />
        </section>
      </div>
      <div class="w-full md:w-2/3 flex flex-col space-y-4">
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Professions</h1>
          <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-2">
            <.profession_card
              :for={character_profession <- @character_professions}
              icon={character_profession.profession.icon}
              name={character_profession.profession.name}
              level={character_profession.level}
              experience={character_profession.experience}
            />
          </div>
        </section>
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Apparel</h1>
          <div class="card bg-base-200 p-4">
            <div class="grid grid-cols-3 gap-2">
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="gem-chain" size="24" />
                </div>
                <span class="font-medium">Trinket</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="crested-helmet" size="24" />
                </div>
                <span class="font-medium">Helmet</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="cloak" size="24" />
                </div>
                <span class="font-medium">Cape</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="hand" size="24" />
                </div>
                <span class="font-medium">Main-Hand</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="chest-armor" size="24" />
                </div>
                <span class="font-medium">Armor</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="hand" size="24" />
                </div>
                <span class="font-medium">Off-Hand</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="ring" size="24" />
                </div>
                <span class="font-medium">Ring</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="boots" size="24" />
                </div>
                <span class="font-medium">Boots</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="necklace" size="24" />
                </div>
                <span class="font-medium">Amulet</span>
              </div>
            </div>
          </div>
        </section>
        <section>
          <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Satchel</h1>
          <div class="card bg-base-200 p-4">
            <div class="grid grid-cols-3 gap-2">
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="potion-ball" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="drink-me" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="shiny-apple" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="pear" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="waterskin" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
              <div class="card bg-base-100 p-4 flex-row items-center rounded-btn gap-4">
                <div class="flex items-center bg-base-200 rounded-lg p-2">
                  <UI.Icons.game name="card-joker" size="24" />
                </div>
                <span class="font-medium">Consumable</span>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
    """
  end

  attr :text, :string, default: nil

  defp bio_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <p :if={@text} class="line-clamp-6"></p>
      <div role="alert" class="alert bg-base-100 text-xs">
        <UI.Icons.page name="info" />
        <p>This character hasn't written their bio yet</p>
      </div>
      <button :if={!@text} class="btn btn-sm btn-neutral mt-4">
        <UI.Icons.page name="pencil" /> Edit bio
      </button>
      <button :if={@text} class="btn btn-sm btn-neutral mt-4">
        <UI.Icons.page name="arrow-right" /> Read more
      </button>
    </div>
    """
  end

  defp guild_card(assigns) do
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
              <UI.Icons.page name="user-round-cog" /> Leader
            </span>
            <span class="badge badge-neutral gap-1">
              <UI.Icons.page name="users" /> 299 members
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :level, :integer, required: true
  attr :experience, :integer, required: true
  attr :icon, :string, default: nil

  defp profession_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <div class="flex gap-2">
        <UI.Media.image src={@icon} placeholder={%{height: 80, width: 80}} class="rounded-xl" />
        <div class="flex flex-col justify-between grow">
          <div class="flex items-center justify-between">
            <span class="font-semibold">{@name}</span>
            <span class="badge badge-accent font-medium">{@level}/99</span>
          </div>
          <progress class="progress progress-primary" value="70" max="100"></progress>
          <div class="flex items-center justify-between mt-1">
            <div class="badge badge-neutral font-medium">XP {@experience} of 100</div>
            <div class="badge badge-neutral font-medium gap-1">
              <UI.Icons.page name="loader" /> 70%
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
