defmodule GEMSWeb.Game.HuntLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.live_component
        id="zone-preview"
        module={GEMSWeb.ZonePreviewComponent}
        zone_id={@selected_character.zone_id}
      />
      <UI.Panels.section title="Hunts" divider>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <.hunt_card :for={hunt <- @hunts} hunt={hunt} />
        </div>
      </UI.Panels.section>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    hunts = GEMS.World.list_avaiable_hunts(character)
    hunt_lookup = Map.new(hunts, &{&1.id, &1})

    {:ok,
     socket
     |> assign(:hunts, hunts)
     |> assign(:hunt_lookup, hunt_lookup)}
  end

  @impl true
  def handle_event("start", %{"id" => hunt_id}, socket) do
    character = socket.assigns.selected_character

    hunt_lookup = socket.assigns.hunt_lookup
    hunt = Map.fetch!(hunt_lookup, hunt_id)

    creature = GEMS.Engine.Schema.Creature.preload(hunt.creature)
    battle = GEMS.Battles.create_duel(character, creature)

    {:ok, identifier} = GEMS.BattleManager.create_battle(battle)

    {:noreply, push_navigate(socket, to: ~p"/game/battles/duel/#{identifier}")}
  end

  attr :hunt, :any, required: true

  defp hunt_card(assigns) do
    ~H"""
    <div class="card card-side bg-base-300 shadow card-border border-base-content/5 ">
      <div class="card-body flex-row p-3">
        <figure class="w-32 aspect-square rounded-box">
          <UI.Media.image placeholder={%{width: 100, height: 100}} />
        </figure>
        <div class="flex flex-col space-y-2 grow">
          <div class="flex items-center">
            <span class="font-semibold grow text-normal md:text-lg">{@hunt.creature.name}</span>
            <button
              phx-click="start"
              phx-value-id={@hunt.id}
              class="btn btn-neutral btn-sm md:btn-md grow max-w-32"
            >
              <UI.Icons.page name="circle-play" class="text-[1.2em] text-success" />
              <span>Hunt</span>
            </button>
          </div>
          <p class="line-clamp-2 text-sm text-base-content/70 break-all">
            {@hunt.creature.description}
          </p>
        </div>
      </div>
    </div>
    """
  end
end
