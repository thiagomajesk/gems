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
        <UI.Lists.cards_with_covers>
          <:card
            :for={zone <- @nearby_zones}
            title={zone.name}
            subtitle={zone.description}
            cover={zone.image}
          >
            <div class="flex items-center justify-between mb-2 text-gray-400">
              <div class="flex items-center gap-2">
                <span class="font-semibold uppercase text-accent">{zone.biome.name}</span>
                <UI.Icons.game name="skull-crack" class={skull_text_color(zone.skull)} />
                <UI.Media.game_icon
                  :if={faction = zone.faction}
                  title={faction.name}
                  icon={faction.icon}
                  fallback="black-flag"
                />
              </div>
              <div class="flex items-center gap-2">
                <div class="badge badge-neutral flex items-center gap-1" title="Danger">
                  <UI.Icons.game name="skull-crossed-bones" />
                  <span>{zone.danger}</span>
                </div>
                <div
                  class={[
                    "badge flex items-center gap-1",
                    (@selected_character.gold >= zone.gold_cost && "badge-neutral") || "badge-error"
                  ]}
                  title="Gold cost"
                >
                  <UI.Icons.game name="two-coins" />
                  <span>{zone.gold_cost}</span>
                </div>
                <div
                  class={[
                    "badge flex items-center gap-1",
                    (@selected_character.stamina >= zone.stamina_cost && "badge-neutral") ||
                      "badge-error"
                  ]}
                  title="Stamina cost"
                >
                  <UI.Icons.game name="run" />
                  <span>{zone.stamina_cost}</span>
                </div>
              </div>
            </div>
            <div class="flex justify-between items-center gap-2 mt-2 pt-2 border-t border-base-content/10">
              <div class="flex items-center gap-1">
                <span
                  :for={activity <- Enum.uniq_by(zone.activities, & &1.profession_id)}
                  title={activity.profession.name}
                  class="px-2 bg-base-content/10 rounded shadow"
                >
                  <UI.Media.game_icon icon={activity.profession.icon} />
                </span>
              </div>
              <.link
                :if={
                  @selected_character.gold >= zone.gold_cost &&
                    @selected_character.stamina >= zone.stamina_cost
                }
                phx-click="travel"
                phx-value-id={zone.id}
                class="btn btn-sm btn-primary"
              >
                <UI.Icons.game name="walking-boot" /> Travel
              </.link>
            </div>
          </:card>
        </UI.Lists.cards_with_covers>
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

  defp skull_text_color(:blue), do: "text-blue-500"
  defp skull_text_color(:yellow), do: "text-yellow-500"
  defp skull_text_color(:red), do: "text-red-500"
  defp skull_text_color(:black), do: "text-black"
end
