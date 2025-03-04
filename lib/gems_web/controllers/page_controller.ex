defmodule GEMSWeb.PageController do
  use GEMSWeb, :controller

  def home(conn, _params), do: redirect(conn, to: ~p"/login")
end
