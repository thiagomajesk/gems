defmodule GEMSWeb.UIKIT.Media do
  use GEMSWeb, :html

  import GEMS.Macros

  attr :avatar, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def avatar(assigns) do
    assigns =
      assign_new(assigns, :src, fn
        %{avatar: %{image: nil}} ->
          nil

        %{avatar: %{image: image}} ->
          GEMS.public_asset_path([image])
      end)

    ~H"""
    <.image
      src={@src}
      {@rest}
      placeholder={%{width: "100", height: "100"}}
      class={["w-full h-full object-cover", @class]}
    />
    """
  end

  attr :icon, :any, required: true
  attr :fallback, :string, default: nil
  attr :rest, :global, include: ~w(size)

  def game_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:name, &(get_in(&1.icon.name) || get_in(&1.fallback)))
      |> assign_new(:color, &(get_in(&1.icon.color) || "current-color"))

    ~H"""
    <UI.Icons.game name={@name || @fallback} style={"color: #{@color}"} {@rest} />
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
