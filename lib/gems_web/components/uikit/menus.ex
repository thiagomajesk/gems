defmodule GEMSWeb.UIKIT.Menus do
  use GEMSWeb, :html

  attr :current_path, :string, required: true

  slot :link, required: true do
    attr :href, :string, required: true
    attr :icon, :string, required: true
    attr :label, :string, required: true
  end

  def global(assigns) do
    ~H"""
    <nav
      id="global-menu"
      phx-hook="SideScroll"
      class="flex items-center overflow-hidden scroll-smooth"
    >
      <ul class={[
        "menu menu-horizontal bg-base-300 rounded-box grow gap-1",
        "flex-nowrap min-w-min snap-x snap-mandatory"
      ]}>
        <li :for={link <- @link} class="snap-center snap-always">
          <.link
            navigate={link.href}
            class={[
              "flex flex-col gap-0.5 items-center min-w-[80px]",
              link.href == @current_path && "active"
            ]}
          >
            <UI.Icons.game name={link.icon} class="text-2xl" noobserver />
            <span class="text-xs">{link.label}</span>
          </.link>
        </li>
      </ul>
    </nav>
    """
  end
end
