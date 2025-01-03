defmodule GEMSWeb.Admin.Database.DashboardLive do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold uppercase">Dashboard</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-8">
      <.insight_card title="Active Accounts" count={@accounts_count} icon="users" />
      <.insight_card title="Active Characters" count={@characters_count} icon="drama" />
      <.insight_card title="Abilities" count={@abilities_count} icon="database" />
      <.insight_card title="Equipments" count={@equipments_count} icon="database" />
      <.insight_card title="Items" count={@items_count} icon="database" />
      <.insight_card title="Professions" count={@professions_count} icon="database" />
      <.insight_card title="States" count={@states_count} icon="database" />
      <.insight_card title="Creatures" count={@creatures_count} icon="database" />
      <.insight_card title="Elements" count={@elements_count} icon="database" />
      <.insight_card title="Biomes" count={@biomes_count} icon="database" />
      <.insight_card title="Ability Types" count={@ability_types_count} icon="database" />
      <.insight_card title="Item Types" count={@item_types_count} icon="database" />
      <.insight_card title="Equipment Types" count={@equipment_types_count} icon="database" />
      <.insight_card title="Creature Types" count={@creature_types_count} icon="database" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    accounts_count = GEMS.Insights.count_active_accounts()
    characters_count = GEMS.Insights.count_active_characters()
    abilities_count = GEMS.Insights.count_abilities()
    equipments_count = GEMS.Insights.count_equipments()
    items_count = GEMS.Insights.count_items()
    professions_count = GEMS.Insights.count_professions()
    states_count = GEMS.Insights.count_states()
    creatures_count = GEMS.Insights.count_creatures()
    elements_count = GEMS.Insights.count_elements()
    biomes_count = GEMS.Insights.count_biomes()
    ability_types_count = GEMS.Insights.count_ability_types()
    item_types_count = GEMS.Insights.count_item_types()
    equipment_types_count = GEMS.Insights.count_equipment_types()
    creature_types_count = GEMS.Insights.count_creature_types()

    {:ok,
     assign(socket,
       accounts_count: accounts_count,
       characters_count: characters_count,
       abilities_count: abilities_count,
       equipments_count: equipments_count,
       items_count: items_count,
       professions_count: professions_count,
       states_count: states_count,
       creatures_count: creatures_count,
       elements_count: elements_count,
       biomes_count: biomes_count,
       ability_types_count: ability_types_count,
       item_types_count: item_types_count,
       equipment_types_count: equipment_types_count,
       creature_types_count: creature_types_count
     )}
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
          <UI.Icons.page name={@icon} size={18} />
        </span>
      </header>
      <span class="text-3xl font-bold text-white">
        {@count}
      </span>
    </div>
    """
  end
end
