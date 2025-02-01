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
        <.bio_section character={@selected_character} />
        <.attributes_section character={@selected_character} />
        <.guild_section :if={@guild} guild={@guild} />
      </div>
      <div class="w-full md:w-2/3 flex flex-col space-y-4">
        <.professions_section character_professions={@character_professions} />
        <.apparel_section />
        <.satchel_section />
      </div>
    </div>
    """
  end

  attr :character, :any, required: true

  defp bio_section(assigns) do
    ~H"""
    <section>
      <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Bio</h1>
      <.bio_card text={@character.bio} />
    </section>
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

  attr :character, :any, required: true

  defp attributes_section(assigns) do
    ~H"""
    <section>
      <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Attributes</h1>
      <div class="grid grid-cols-3 gap-2">
        <.attribute_card name={:strength} value={@character.strength} />
        <.attribute_card name={:dexterity} value={@character.dexterity} />
        <.attribute_card name={:intelligence} value={@character.intelligence} />
      </div>
    </section>
    """
  end

  attr :name, :atom, required: true, values: [:strength, :dexterity, :intelligence]
  attr :value, :integer, required: true

  defp attribute_card(assigns) do
    ~H"""
    <div class={[
      "rounded-box flex flex-col items-center justify-center h-24 gap-2 p-2 relative",
      "bg-gradient-to-br from-base-300",
      attribute_gradient_stop(@name)
    ]}>
      <UI.Icons.game
        name={attribute_icon(@name)}
        size="unset"
        class={["h-full w-full absolute inset-0", attribute_text_color(@name)]}
      />
      <span class="font-bold tabular-nums text-xl bg-base-300/50 backdrop-blur-sm px-2 py-1 rounded-btn shadow size-12 flex items-center justify-center">
        {@value}
      </span>
      <small class="absolute bottom-2 right-2 font-semibold uppercase">
        {attribute_label(@name)}
      </small>
    </div>
    """
  end

  attr :guild, :any, required: true

  defp guild_section(assigns) do
    ~H"""
    <section>
      <h1 class="font-semibold ml-1 mb-2 uppercase text-lg">Guild</h1>
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
    </section>
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

  attr :character_professions, :list, required: true

  defp professions_section(assigns) do
    ~H"""
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
    """
  end

  defp apparel_section(assigns) do
    ~H"""
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
    """
  end

  defp satchel_section(assigns) do
    ~H"""
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
    """
  end

  defp attribute_icon(:strength), do: "biceps"
  defp attribute_icon(:dexterity), do: "sprint"
  defp attribute_icon(:intelligence), do: "brain"

  defp attribute_text_color(:strength), do: "text-rose-500"
  defp attribute_text_color(:dexterity), do: "text-emerald-500"
  defp attribute_text_color(:intelligence), do: "text-indigo-500"

  defp attribute_label(:strength), do: "STR"
  defp attribute_label(:dexterity), do: "DEX"
  defp attribute_label(:intelligence), do: "INT"

  defp attribute_gradient_stop(:strength), do: "to-rose-500/10"
  defp attribute_gradient_stop(:dexterity), do: "to-emerald-500/10"
  defp attribute_gradient_stop(:intelligence), do: "to-indigo-500/10"
end
