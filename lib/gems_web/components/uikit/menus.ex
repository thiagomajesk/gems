defmodule GEMSWeb.UIKIT.Menus do
  use GEMSWeb, :html

  attr :current_path, :string, required: true

  slot :link, required: true do
    attr :href, :string, required: true
    attr :icon, :string, required: true
    attr :label, :string, required: true
    attr :active, :boolean, required: false
  end

  def global(assigns) do
    ~H"""
    <nav
      id="global-menu"
      phx-hook="SideScroll"
      class="flex items-center overflow-hidden scroll-smooth h-[100px] my-1"
    >
      <ul class={[
        "menu menu-horizontal bg-base-200 rounded-box grow",
        "flex-nowrap min-w-min snap-x snap-mandatory"
      ]}>
        <li :for={link <- @link} class="snap-center snap-always">
          <.link
            navigate={link.href}
            class={[
              "flex flex-col gap-0.5 min-w-[60px]",
              link.href == @current_path && "active"
            ]}
          >
            <UI.Icons.game name={link.icon} size={26} noobserver />
            <span>{link.label}</span>
          </.link>
        </li>
      </ul>
    </nav>
    """
  end
end
