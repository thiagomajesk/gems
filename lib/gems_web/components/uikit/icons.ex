defmodule GEMSWeb.UIKIT.Icons do
  @moduledoc """
  This module works by relying on the icons provided by the iconify-icon package.
  See this page for more information about it: https://docs.iconify.design/iconify-icon/
  """
  use GEMSWeb, :html

  @global_attrs ~w(size rotate inline flip noobserver)

  attr :name, :string, required: true
  attr :rest, :global, include: @global_attrs

  def page(assigns) do
    ~H"""
    <.iconify icon={"lucide:#{@name}"} {@rest} />
    """
  end

  attr :name, :string, required: true
  attr :rest, :global, include: @global_attrs

  def symbols(assigns) do
    ~H"""
    <.iconify icon={"material-symbols:#{@name}"} {@rest} />
    """
  end

  attr :name, :string, required: true
  attr :rest, :global, include: @global_attrs

  def game(assigns) do
    ~H"""
    <.iconify icon={"game-icons:#{@name}"} {@rest} />
    """
  end

  @doc ~S"""
  Renders an icon from the Game Icons icon set.
  All the available icons can be found here in the following page:
  https://icon-sets.iconify.design/game-icons.

  ## Examples

  ```heex
  <.iconify icon="3d-glasses" />
  <.iconify icon="3d-glasses" size="64" />
  <.iconify icon="3d-glasses" inline />
  <.iconify icon="3d-glasses" rotate="90deg" />
  <.iconify icon="3d-glasses" flip="vertical" />
  <.iconify icon="3d-glasses" class="text-red-100 bg-red-500" />
  ```

  Sizing the icons might be a bit tricky in some scenarios, sometimes you want to specify the size through
  the component, other times you might want to specify the size through CSS, see the official documentation
  for guidance on the available options: https://iconify.design/docs/iconify-icon/dimensions.html.
  """

  attr :icon, :string, required: true
  attr :size, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: @global_attrs

  def iconify(assigns) do
    ~H"""
    <iconify-icon
      icon={@icon}
      width={@size}
      height={@size}
      class={[@size != nil && "size-min", @class]}
      {@rest}
    >
    </iconify-icon>
    """
  end
end
