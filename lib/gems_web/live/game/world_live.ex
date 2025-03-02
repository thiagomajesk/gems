defmodule GEMSWeb.Game.WorldLive do
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
      <UI.Panels.section title="Nearby Zones" divider>
        <div class="flex fle-col space-y-2">
          <.zone_card :for={zone <- @nearby_zones} zone={zone} character={@selected_character} />
        </div>
      </UI.Panels.section>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    nearby_zones = GEMS.World.list_nearby_zones(character.zone_id)
    {:ok, assign(socket, nearby_zones: nearby_zones)}
  end

  @impl true
  def handle_event("travel", %{"id" => zone_id}, socket) do
    character = socket.assigns.selected_character
    character = GEMS.World.travel(character, zone_id)
    nearby_zones = GEMS.World.list_nearby_zones(character.zone_id)

    {:noreply,
     socket
     |> assign(:selected_character, character)
     |> assign(:nearby_zones, nearby_zones)}
  end

  attr :zone, :any, required: true
  attr :character, :any, required: true

  defp zone_card(assigns) do
    ~H"""
    <div class="card card-side bg-base-300 shadow card-border border-base-content/5 max-h-56">
      <figure class="min-w-1/4 min-w-42">
        <UI.Media.image
          src={GEMS.public_asset_path(@zone.image)}
          placeholder={%{width: 100, height: 100}}
        />
      </figure>
      <div class="card-body p-3 space-y-2">
        <div class="flex items-center">
          <span class="font-semibold grow text-normal md:text-lg">{@zone.name}</span>
          <div class="flex items-center gap-2">
            <.link
              :if={
                @character.gold >= @zone.gold_cost &&
                  @character.stamina >= @zone.stamina_cost
              }
              phx-click="travel"
              phx-value-id={@zone.id}
              class="btn btn-neutral btn-sm md:btn-md grow max-w-32"
            >
              <UI.Icons.game name="walking-boot" /> Travel
            </.link>
          </div>
        </div>
        <p class="line-clamp-2 text-sm text-base-content/70 break-all">
          {@zone.description}
        </p>
        <div class="flex items-center flex-wrap gap-2">
          <UI.Icons.game name="skull-crack" class={skull_text_color(@zone.skull)} />
          <UI.Media.game_icon
            :if={faction = @zone.faction}
            title={faction.name}
            icon={faction.icon}
            fallback="black-flag"
          />
          <span class="badge badge-sm md:badge-md badge-soft badge-accent font-medium gap-1">
            {@zone.biome.name}
          </span>
          <span
            class="badge badge-sm md:badge-md bg-base-content/5 border-base-content/10 flex items-center gap-1"
            title="Danger"
          >
            <UI.Icons.game name="skull-crossed-bones" />
            <span>{@zone.danger}</span>
          </span>
          <span
            class={[
              "badge badge-sm md:badge-md flex items-center gap-1",
              (@character.gold >= @zone.gold_cost && "bg-base-content/5 border-base-content/10 ") ||
                "badge-error"
            ]}
            title="Gold cost"
          >
            <UI.Icons.game name="two-coins" />
            <span>{@zone.gold_cost}</span>
          </span>
          <span
            class={[
              "badge badge-sm md:badge-md flex items-center gap-1",
              (@character.stamina >= @zone.stamina_cost && "bg-base-content/5 border-base-content/10") ||
                "badge-error"
            ]}
            title="Stamina cost"
          >
            <UI.Icons.game name="run" />
            <span>{@zone.stamina_cost}</span>
          </span>
        </div>
        <div class="flex items-center gap-2 border-t border-base-content/10 pt-2">
          <span
            :for={activity <- Enum.uniq_by(@zone.activities, & &1.profession_id)}
            title={activity.profession.name}
            class="px-2 bg-base-content/5 rounded-sm shadow-sm"
          >
            <UI.Media.game_icon icon={activity.profession.icon} />
          </span>
        </div>
      </div>
    </div>
    """
  end

  defp skull_text_color(:blue), do: "text-blue-500"
  defp skull_text_color(:yellow), do: "text-yellow-500"
  defp skull_text_color(:red), do: "text-red-500"
  defp skull_text_color(:black), do: "text-black"
end
