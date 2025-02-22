defmodule GEMSWeb.ZonePreviewComponent do
  use GEMSWeb, :live_component

  alias GEMS.World.Schema.Zone

  def render(assigns) do
    ~H"""
    <section
      id={"#{@id}-wrapper"}
      class="mb-8 relative overflow-hidden rounded-lg grow shadow-xl cursor-pointer"
      phx-click={expand("##{@id}-drawer")}
    >
      <UI.Media.image
        src={GEMS.public_asset_path(@zone.image)}
        class={[
          "max-h-64 w-full object-cover transition-all",
          "duration-300 delay-0 hover:delay-700 hover:duration-1000 ease-spring hover:max-h-screen hover:scale-105"
        ]}
      />
      <header class="absolute bottom-0 p-4 w-full bg-base-300/50 backdrop-blur">
        <div class="flex flex-col space-y-2 h-full">
          <div class="flex items-center text-2xl justify-between">
            <strong>{@zone.name}</strong>
            <div class="flex items-center gap-2">
              <UI.Icons.game name="skull-crack" class={skull_text_color(@zone.skull)} />
              <UI.Media.game_icon
                :if={faction = @zone.faction}
                title={faction.name}
                icon={faction.icon}
                fallback="black-flag"
              />
            </div>
          </div>
          <div id={"#{@id}-drawer"} class="hidden transform-gpu flex-col space-y-2">
            <p class="text-sm text-base-content/50">{@zone.description}</p>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
              <div
                class="px-1 rounded-btn bg-base-content/10 shadow flex items-center justify-between"
                title="Crafting"
              >
                <span class="flex items-center gap-2">
                  <UI.Icons.page name="circle-fading-arrow-up" /> Crafting
                </span>
                <span class="font-medium">+10%</span>
              </div>
              <div
                class="px-1 rounded-btn bg-base-content/10 shadow flex items-center justify-between"
                title="Gathering"
              >
                <span class="flex items-center gap-2">
                  <UI.Icons.page name="circle-fading-arrow-up" /> Gathering
                </span>
                <span class="font-medium">+10%</span>
              </div>
              <div
                class="px-1 rounded-btn bg-base-content/10 shadow flex items-center justify-between"
                title="Farming"
              >
                <span class="flex items-center gap-2">
                  <UI.Icons.page name="circle-fading-arrow-up" /> Farmning
                </span>
                <span class="font-medium">+10%</span>
              </div>
              <div
                class="px-1 rounded-btn bg-base-content/10 shadow flex items-center justify-between"
                title="Combat"
              >
                <span class="flex items-center gap-2">
                  <UI.Icons.page name="circle-fading-arrow-up" /> Combat
                </span>
                <span class="font-medium">+10%</span>
              </div>
            </div>
          </div>
        </div>
      </header>
    </section>
    """
  end

  def update(assigns, socket) do
    assigns = fetch_assigns(assigns, [:id, :zone_id])

    {:ok,
     socket
     |> assign(assigns)
     |> assign(zone: Zone.get!(assigns.zone_id))}
  end

  defp expand(id) do
    JS.toggle(
      to: id,
      display: "flex",
      in: {
        "duration-300 ease-in-out",
        "opacity-0 translate-y-1 scale-98",
        "opacity-100 translate-y-0 scale-100"
      },
      out: {
        "duration-300 ease-in-out",
        "opacity-100 translate-y-0 scale-100",
        "opacity-0 translate-y-1 scale-98"
      }
    )
  end

  defp skull_text_color(:blue), do: "text-blue-500"
  defp skull_text_color(:yellow), do: "text-yellow-500"
  defp skull_text_color(:red), do: "text-red-500"
  defp skull_text_color(:black), do: "text-black"
end
