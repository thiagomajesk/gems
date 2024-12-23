defmodule GEMSWeb.CharacterSelectionController do
  use GEMSWeb, :controller

  def create(conn, %{"id" => character_id}) do
    user = conn.assigns.current_user

    if character = GEMS.Characters.get_character(user, character_id) do
      conn
      |> put_session(:character_id, character.id)
      |> redirect(to: ~p"/game/home")
    else
      conn
      |> put_flash(:error, "Invalid character")
      |> redirect(to: ~p"/accounts/characters")
    end
  end
end
