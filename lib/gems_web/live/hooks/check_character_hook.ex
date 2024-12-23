defmodule GEMSWeb.CheckCharacterHook do
  use GEMSWeb, :verified_routes

  def on_mount(:ensure_selected_character, _params, session, socket) do
    socket = mount_selected_character(socket, session)

    if socket.assigns.selected_character do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must select a character first")
        |> Phoenix.LiveView.redirect(to: ~p"/accounts/characters")

      {:halt, socket}
    end
  end

  defp mount_selected_character(socket, session) do
    user = socket.assigns.current_user

    Phoenix.Component.assign_new(socket, :selected_character, fn ->
      if character_id = session["character_id"] do
        GEMS.Characters.get_character(user, character_id)
      end
    end)
  end
end
