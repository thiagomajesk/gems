defmodule GEMSWeb.Admin.Database.DashboardLive do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold uppercase">Dashboard</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-8">
      <.insight_card title="Active Accounts" count={@accounts_count} icon="users" />
      <.insight_card title="Active Characters" count={@characters_count} icon="drama" />
      <.insight_card title="Skills" count={@skills_count} icon="database" />
      <.insight_card title="Equipments" count={@equipments_count} icon="database" />
      <.insight_card title="Items" count={@items_count} icon="database" />
      <.insight_card title="Professions" count={@professions_count} icon="database" />
      <.insight_card title="States" count={@states_count} icon="database" />
      <.insight_card title="Creatures" count={@creatures_count} icon="database" />
      <.insight_card title="Elements" count={@elements_count} icon="database" />
      <.insight_card title="Biomes" count={@biomes_count} icon="database" />
      <.insight_card title="Skill Types" count={@skill_types_count} icon="database" />
      <.insight_card title="Item Types" count={@item_types_count} icon="database" />
      <.insight_card title="Equipment Types" count={@equipment_types_count} icon="database" />
      <.insight_card title="Creature Types" count={@creature_types_count} icon="database" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    accounts_count = GEMS.Insights.count_active_accounts()
    characters_count = GEMS.Insights.count_active_characters()
    skills_count = GEMS.Insights.count_skills()
    equipments_count = GEMS.Insights.count_equipments()
    items_count = GEMS.Insights.count_items()
    professions_count = GEMS.Insights.count_professions()
    states_count = GEMS.Insights.count_states()
    creatures_count = GEMS.Insights.count_creatures()
    elements_count = GEMS.Insights.count_elements()
    biomes_count = GEMS.Insights.count_biomes()
    skill_types_count = GEMS.Insights.count_skill_types()
    item_types_count = GEMS.Insights.count_item_types()
    equipment_types_count = GEMS.Insights.count_equipment_types()
    creature_types_count = GEMS.Insights.count_creature_types()

    {:ok,
     assign(socket,
       accounts_count: accounts_count,
       characters_count: characters_count,
       skills_count: skills_count,
       equipments_count: equipments_count,
       items_count: items_count,
       professions_count: professions_count,
       states_count: states_count,
       creatures_count: creatures_count,
       elements_count: elements_count,
       biomes_count: biomes_count,
       skill_types_count: skill_types_count,
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
    <div class="card bg-base-100 shadow">
      <div class="card-body gap-2">
        <div class="flex items-start justify-between gap-2 text-sm">
          <div>
            <p class="text-base-content/80 font-medium">{@title}</p>
            <div class="mt-3 flex items-center gap-2">
              <p class="text-2xl font-semibold">{@count}</p>
            </div>
          </div>
          <div class="bg-base-200 rounded-box flex items-center p-2">
            <UI.Icons.page name={@icon} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
