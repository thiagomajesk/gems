defmodule GEMSWeb.Game.WorldLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 gap-4">
      <.zone_card :for={zone <- @nearby_zones} zone={zone} />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character
    nearby_zones = GEMS.World.list_nearby_zones(character.zone_id)
    {:ok, assign(socket, nearby_zones: nearby_zones)}
  end

  attr :zone, :map, required: true

  defp zone_card(assigns) do
    ~H"""
    <div class="card bg-base-200 p-4">
      <div class="flex gap-2">
        <UI.Media.image src={@zone.icon} placeholder={%{height: 100, width: 100}} class="rounded-xl" />
        <div class="flex flex-col justify-between grow">
          <div class="flex flex-col">
            <span class="font-semibold">{@zone.name}</span>
            <p class="text-sm">{@zone.description}</p>
          </div>
          <div>
            <span class="badge badge-neutral flex-items-center gap-2">
              <UI.Icons.page name="leaf" />
              {Recase.to_title("#{@zone.biome.name}")}
            </span>
            <span class="badge badge-neutral flex-items-center gap-2">
              <UI.Icons.page name="skull" />
              {Recase.to_title("#{@zone.skull} Skull")}
            </span>
            <span class="badge badge-neutral flex-items-center gap-2">
              <UI.Icons.page name="triangle-alert" />
              {Recase.to_title("Danger Level #{@zone.danger}")}
            </span>
          </div>

          <div class="flex w-full mt-4">
            <div>Activities...</div>
            <button class="btn btn-sm btn-primary ml-auto">Travel</button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
