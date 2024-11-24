defmodule GEMSWeb.UIKIT.Media do
  @moduledoc """
  This module works by relying on the icons provided by the iconify-icon package.
  See this page for more information about it: https://docs.iconify.design/iconify-icon/
  """
  use GEMSWeb, :html

  attr(:name, :string, required: true)
  attr(:size, :integer, default: 18)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(rotate inline flip))

  def icon(assigns) do
    ~H"""
    <iconify-icon
      icon={"lucide:#{@name}"}
      width={@size}
      height={@size}
      class={["size-min", @class]}
      {@rest}
    >
    </iconify-icon>
    """
  end

  @doc ~S"""
  Renders an icon from the Game Icons icon set.
  All the available icons can be found here in the following page:
  https://icon-sets.iconify.design/game-icons.

  ## Examples

  ```heex
  <.gicon name="3d-glasses" />
  <.gicon name="3d-glasses" size="64" />
  <.gicon name="3d-glasses" inline />
  <.gicon name="3d-glasses" rotate="90deg" />
  <.gicon name="3d-glasses" flip="vertical" />
  <.gicon name="3d-glasses" class="text-red-100 bg-red-500" />
  ```
  """

  attr(:name, :string, required: true)
  attr(:size, :integer, default: 18)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(rotate inline flip))

  def gicon(assigns) do
    ~H"""
    <iconify-icon
      icon={"game-icons:#{@name}"}
      width={@size}
      height={@size}
      class={["size-min", @class]}
      {@rest}
    >
    </iconify-icon>
    """
  end
end
