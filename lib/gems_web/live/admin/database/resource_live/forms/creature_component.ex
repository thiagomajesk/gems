defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.CreatureComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.ResourceLive.Forms.TraitsAssocInput

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/creatures"}>
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
          <div class="space-y-6">
            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input type="text" field={f[:name]} label="Name" />
              <Forms.field_input type="text" field={f[:code]} label="Code" />
            </div>
            <Forms.field_input type="textarea" field={f[:description]} label="Description" />

            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input
                type="select"
                field={f[:type_id]}
                label="Type"
                options={@type_options}
              />

              <Forms.field_input
                type="select"
                field={f[:biome_id]}
                label="Biome"
                options={@biome_options}
              />
            </div>

            <Forms.fieldset legend="Stats" class="grid grid-cols-2 md:grid-cols-3 gap-6">
              <Forms.field_input type="number" field={f[:max_health]} label="Max Health" />
              <Forms.field_input type="number" field={f[:max_energy]} label="Max Energy" />
              <Forms.field_input type="number" field={f[:physical_damage]} label="Physical Damage" />
              <Forms.field_input type="number" field={f[:magical_damage]} label="Magical Damage" />
              <Forms.field_input type="number" field={f[:physical_defense]} label="Physical Defense" />
              <Forms.field_input type="number" field={f[:magical_defense]} label="Magical Defense" />
              <Forms.field_input type="number" field={f[:health_regen]} label="Health Regen" />
              <Forms.field_input type="number" field={f[:energy_regen]} label="Energy Regen" />
              <Forms.field_input type="number" field={f[:accuracy]} label="Accuracy" />
              <Forms.field_input type="number" field={f[:evasion]} label="Evasion" />
              <Forms.field_input type="number" field={f[:attack_speed]} label="Attack Speed" />
              <Forms.field_input type="number" field={f[:break_power]} label="Break Power" />
              <Forms.field_input type="number" field={f[:critical_rating]} label="Critical Rating" />
              <Forms.field_input type="number" field={f[:critical_power]} label="Critical Power" />
              <Forms.field_input type="number" field={f[:weapon_power]} label="Weapon Power" />
              <Forms.field_input type="number" field={f[:ability_power]} label="Ability Power" />
              <Forms.field_input type="number" field={f[:resilience]} label="Resilience" />
              <Forms.field_input type="number" field={f[:lehality]} label="Lethality" />
            </Forms.fieldset>
          </div>
          <Forms.fieldset legend="Traits">
            <TraitsAssocInput.inputs_for_assoc field={f[:traits]} />
          </Forms.fieldset>
        </div>
      </Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    biome_options = GEMS.Engine.Schema.Biome.options()
    type_options = GEMS.Engine.Schema.CreatureType.options()

    {:ok,
     socket
     |> assign(:biome_options, biome_options)
     |> assign(:type_options, type_options)}
  end
end
