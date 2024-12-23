defmodule GEMSWeb.Game.HomeLive do
  use GEMSWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Home
    """
  end
end
