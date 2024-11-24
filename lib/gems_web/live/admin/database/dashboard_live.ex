defmodule GEMSWeb.Admin.Database.DashboardLive do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold uppercase">Dashboard</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-8">
      <.insight_card title="Active Accounts" count={@accounts_count} icon="users" />
      <.insight_card title="Active Characters" count={@characters_count} icon="drama" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    accounts_count = GEMS.Accounts.count_active_accounts()
    characters_count = GEMS.Characters.count_active_characters()

    {:ok, assign(socket, accounts_count: accounts_count, characters_count: characters_count)}
  end

  attr :title, :string, required: true
  attr :count, :integer, required: true
  attr :icon, :string, required: true

  defp insight_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-base-200 shadow-md rounded-box p-4">
      <header class="flex flex-items justify-between">
        <span class="font-semibold text-sm uppercase">{@title}</span>
        <span class="flex items-center justify-center rounded-btn p-2 bg-base-300">
          <UI.Media.icon name={@icon} size={18} />
        </span>
      </header>
      <span class="text-3xl font-bold text-white">
        {@count}
      </span>
    </div>
    """
  end
end
