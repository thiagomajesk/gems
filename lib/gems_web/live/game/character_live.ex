defmodule GEMSWeb.Game.CharacterLive do
  use GEMSWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.live_component
        id="zone-preview"
        module={GEMSWeb.ZonePreviewComponent}
        zone_id={@selected_character.zone_id}
      />
      <div class="flex flex-col md:flex-row gap-4">
        <div class="w-full md:w-1/3 flex flex-col space-y-4">
          <.bio_section character={@selected_character} />
          <.info_section character={@selected_character} />
          <.stats_section character={@selected_character} />
          <.guild_section :if={@guild} guild={@guild} />
        </div>
        <div class="w-full md:w-2/3 flex flex-col space-y-4">
          <UI.Navigation.tabs current_path={~p"/game/character"} current_action={@action}>
            <:tabs action={:inventory} label="Inventory">
              <.apparel_section />
              <.satchel_section />
            </:tabs>
            <:tabs action={:professions} label="Professions">
              <.professions_section character_professions={@character_professions} />
            </:tabs>
          </UI.Navigation.tabs>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character

    guild = GEMS.Characters.get_character_guild(character)
    character_professions = GEMS.Characters.list_character_professions(character, [:profession])

    {:ok, assign(socket, guild: guild, character_professions: character_professions)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case Map.get(params, "showing", "inventory") do
      "inventory" ->
        {:noreply, assign(socket, :action, :inventory)}

      "professions" ->
        {:noreply, assign(socket, :action, :professions)}
    end
  end

  attr :character, :any, required: true

  defp info_section(assigns) do
    ~H"""
    <UI.Panels.section title="Info">
      <dl class="card bg-base-300 p-4 divide-y divide-dotted divide-base-content/20">
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="character" class="text-indigo-500" />
            <span>Name</span>
          </dt>
          <dd>{@character.name}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="winged-shield" class="text-orange-500" />
            <span>Class</span>
          </dt>
          <dd>{@character.class.name}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="up-card" class="text-yellow-500" />
            <span>Level</span>
          </dt>
          <dd>{@character.level}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="chart" class="text-green-500" />
            <span>Experience</span>
          </dt>
          <dd>{@character.experience}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="run" class="text-amber-500" />
            <span>Stamina</span>
          </dt>
          <dd>{@character.stamina}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="striped-sun" class="text-cyan-500" />
            <span>Souls</span>
          </dt>
          <dd>{@character.souls}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="trophy" class="text-purple-500" />
            <span>Fame</span>
          </dt>
          <dd>{@character.fame}</dd>
        </div>
      </dl>
    </UI.Panels.section>
    """
  end

  attr :character, :any, required: true

  defp stats_section(assigns) do
    ~H"""
    <UI.Panels.section title="Stats">
      <dl class="card bg-base-300 p-4 divide-y divide-dotted divide-base-content/20">
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="heart-beats" class="text-rose-500" />
            <span>Health</span>
          </dt>
          <dd>{@character.maximum_health}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="bolt-drop" class="text-cyan-500" />
            <span>Energy</span>
          </dt>
          <dd>{@character.maximum_energy}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="heart-plus" />
            <span>Health Regeneration</span>
          </dt>
          <dd>{@character.health_regeneration}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="droplets" />
            <span>Energy Regeneration</span>
          </dt>
          <dd>{@character.energy_regeneration}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="checked-shield" />
            <span>Physical Armor</span>
          </dt>
          <dd>{@character.physical_armor}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="magic-shield" />
            <span>Magical Armor</span>
          </dt>
          <dd>{@character.magical_armor}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="bullseye" />
            <span>Accuracy Rating</span>
          </dt>
          <dd>{@character.accuracy_rating}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="dodging" />
            <span>Evasion Rating</span>
          </dt>
          <dd>{@character.evasion_rating}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="target-dummy" />
            <span>Critical Rating</span>
          </dt>
          <dd>{@character.critical_rating}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="healing-shield" />
            <span>Recovery Rating</span>
          </dt>
          <dd>{@character.recovery_rating}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="strong" />
            <span>Fortitude Rating</span>
          </dt>
          <dd>{@character.fortitude_rating}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="sun-spear" />
            <span>Damage Penetration</span>
          </dt>
          <dd>{@character.damage_penetration}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="broken-shield" />
            <span>Damage Reflection</span>
          </dt>
          <dd>{@character.damage_reflection}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="armor-upgrade" class="text-red-400" />
            <span>Fire resistance</span>
          </dt>
          <dd>{@character.fire_resistance || "---"}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="armor-upgrade" class="text-blue-400" />
            <span>Water resistance</span>
          </dt>
          <dd>{@character.water_resistance || "---"}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="armor-upgrade" class="text-green-400" />
            <span>Earth resistance</span>
          </dt>
          <dd>{@character.earth_resistance || "---"}</dd>
        </div>
        <div class="flex items-center justify-between gap-2 py-1">
          <dt class="flex items-center gap-2">
            <UI.Icons.game name="armor-upgrade" class="text-purple-400" />
            <span>Air resistance</span>
          </dt>
          <dd>{@character.air_resistance || "---"}</dd>
        </div>
      </dl>
    </UI.Panels.section>
    """
  end

  attr :character, :any, required: true

  defp bio_section(assigns) do
    ~H"""
    <UI.Panels.section title="Bio">
      <.bio_card text={@character.bio} />
    </UI.Panels.section>
    """
  end

  attr :text, :string, default: nil

  defp bio_card(assigns) do
    ~H"""
    <div class="card bg-base-300 p-4">
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

  attr :guild, :any, required: true

  defp guild_section(assigns) do
    ~H"""
    <UI.Panels.section title="Guild">
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
    </UI.Panels.section>
    """
  end

  attr :character_professions, :list, required: true

  defp professions_section(assigns) do
    ~H"""
    <UI.Panels.section title="Professions">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <.profession_card
          :for={character_profession <- @character_professions}
          icon={character_profession.profession.icon}
          name={character_profession.profession.name}
          level={character_profession.level}
          experience={character_profession.experience}
        />
      </div>
    </UI.Panels.section>
    """
  end

  attr :name, :string, required: true
  attr :level, :integer, required: true
  attr :experience, :integer, required: true
  attr :icon, :string, default: nil

  defp profession_card(assigns) do
    assigns =
      assigns
      |> assign_new(:max, &GEMS.Leveling.profession_experience(&1.level))
      |> assign_new(:progress, &Float.round(&1.experience / &1.max * 100, 2))

    ~H"""
    <div class="card bg-base-100 shadow-xs p-2">
      <UI.Progress.profession value={@experience} max={@max} />
      <div class="card-body flex-row items-center p-2">
        <div class="bg-base-300 rounded-box flex items-center p-2">
          <UI.Media.game_icon icon={@icon} class="text-4xl" />
        </div>
        <div class="flex flex-col justify-between grow space-y-2">
          <div class="flex items-center justify-between">
            <span class="font-semibold">{@name}</span>
            <span class="badge badge-sm badge-accent font-medium">LV {@level}</span>
          </div>
          <div class="flex items-center justify-between mt-1">
            <div class="badge badge-ghost badge-sm">
              {"#{@experience} of #{@max} XP"}
            </div>
            <div class="badge badge-ghost badge-sm gap-2">
              <UI.Icons.page name="loader" /> {"#{@progress}%"}
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp apparel_section(assigns) do
    ~H"""
    <UI.Panels.section title="Apparel">
      <div class="grid grid-cols-3 gap-2">
        <.slot_card icon="gem-chain" name="Trinket" />
        <.slot_card icon="crested-helmet" name="Helmet" />
        <.slot_card icon="cloak" name="Cape" />
        <.slot_card icon="hand" name="Main-Hand" />
        <.slot_card icon="chest" name="Armor" />
        <.slot_card icon="hand" name="Off-Hand" />
        <.slot_card icon="ring" name="Ring" />
        <.slot_card icon="boots" name="Boots" />
        <.slot_card icon="necklace" name="Necklace" />
      </div>
    </UI.Panels.section>
    """
  end

  defp satchel_section(assigns) do
    ~H"""
    <UI.Panels.section title="Satchel">
      <div class="grid grid-cols-3 gap-2">
        <.slot_card icon="potion-ball" name="Consumable" />
        <.slot_card icon="drink-me" name="Consumable" />
        <.slot_card icon="shiny-apple" name="Consumable" />
        <.slot_card icon="pear" name="Consumable" />
        <.slot_card icon="waterskin" name="Consumable" />
        <.slot_card icon="card-joker" name="Consumable" />
      </div>
    </UI.Panels.section>
    """
  end

  attr :icon, :string, required: true
  attr :name, :string, required: true

  defp slot_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-xs shadow">
      <div class="card-body items-center p-3">
        <div class="bg-base-300 rounded-box flex items-center p-2">
          <UI.Icons.game name={@icon} class="text-2xl" />
        </div>
        <span class="font-medium">{@name}</span>
      </div>
    </div>
    """
  end
end
