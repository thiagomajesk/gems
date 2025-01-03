defmodule GEMSWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use GEMSWeb, :controller` and
  `use GEMSWeb, :live_view`.
  """
  use GEMSWeb, :html

  embed_templates "layouts/*"

  defp annoucement_banner(assigns) do
    ~H"""
    <div role="alert" class="alert alert-info shadow-xl rounded-none sticky">
      <UI.Icons.page name="info" size={18} />
      <div class="text-sm">
        <h3 class="font-bold">Attention!</h3>
        <p>You are currently using a beta version of this software</p>
      </div>
    </div>
    """
  end
end
