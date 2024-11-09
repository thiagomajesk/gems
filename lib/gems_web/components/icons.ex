defmodule GEMSWeb.Components.Icons do
  @moduledoc """
  This module works by relying on the icons provided by the iconify-icon package.
  See this page for more information about it: https://docs.iconify.design/iconify-icon/
  """
  use GEMSWeb, :html

  attr(:name, :string, required: true)
  attr(:size, :integer, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(rotate inline flip))

  def web(assigns) do
    ~H"""
    <iconify-icon
      icon={"material-symbols:#{@name}"}
      width={@size}
      height={@size}
      class={["size-min", @class]}
      {@rest}
    >
    </iconify-icon>
    """
  end

  attr(:name, :string, required: true)
  attr(:size, :integer, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(rotate inline flip))

  def game(assigns) do
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
