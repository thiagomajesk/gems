defmodule GEMSWeb.UIKIT.Media do
  use GEMSWeb, :html

  import GEMS.Macros

  attr :avatar, :map, required: true
  attr :rest, :global

  def avatar(assigns) do
    assigns =
      assign_new(assigns, :src, fn
        %{avatar: %{icon: nil}} ->
          nil

        %{avatar: %{icon: icon}} ->
          GEMS.public_asset_path(["avatars", icon])
      end)

    ~H"""
    <.image src={@src} {@rest} placeholder={%{width: "100", height: "100"}} />
    """
  end

  attr :src, :string, default: nil
  attr :placeholder, :map, default: %{}
  attr :rest, :global

  def image(assigns) do
    assigns = assign_placeholder(assigns)

    ~H"""
    <img src={@src || @placeholder} {@rest} draggable="false" />
    """
  end

  defp assign_placeholder(assigns) do
    maybe(assigns, placeholder = assigns[:placeholder], fn assigns ->
      width = placeholder[:width] || 100
      height = placeholder[:height] || 100
      background = placeholder[:background] || "000000"
      foreground = placeholder[:foreground] || "ffffff"

      assign(
        assigns,
        :placeholder,
        "https://placehold.co/#{width}x#{height}/#{background}/#{foreground}"
      )
    end)
  end
end
