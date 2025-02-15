defmodule GEMSWeb.UIKIT.Panels do
  use GEMSWeb, :html

  attr :tag, :string, default: "div"
  attr :rest, :global
  slot :inner_block, required: true

  def container(assigns) do
    ~H"""
    <.dynamic_tag tag_name={@tag} class="xl:container xl:mx-auto px-4 xl:px-0" {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end

  attr :heading, :string, values: ~w(h1 h2 h3 h4 h5 h6), default: "h6"
  attr :title, :string, required: true
  attr :divider, :boolean, default: false
  slot :inner_block, required: true

  def section(assigns) do
    ~H"""
    <section class="w-full">
      <header class={["mb-4", @divider && "border-b-2 border-base-content/50"]}>
        <.dynamic_tag tag_name={@heading} class="uppercase font-bold">
          {@title}
        </.dynamic_tag>
      </header>
      <div>
        {render_slot(@inner_block)}
      </div>
    </section>
    """
  end
end
