defmodule GEMSWeb.UIKIT.Media do
  use GEMSWeb, :html

  attr :avatar, :map, required: true
  attr :rest, :global

  def avatar(assigns) do
    assigns =
      assign_new(assigns, :src, fn %{avatar: avatar} ->
        avatar_path = ["avatars", avatar.icon]
        system_path = avatar_path
        Path.join(GEMSWeb.Endpoint.url(), system_path)
      end)

    ~H"""
    <img src={@src} {@rest} />
    """
  end
end
