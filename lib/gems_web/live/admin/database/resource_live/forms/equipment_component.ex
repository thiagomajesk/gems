defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.EquipmentComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.ResourceLive.Forms.TraitsAssocInput

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/equipments"}>
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
          <div class="space-y-6">
            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input type="text" field={f[:name]} label="Name" />
              <Forms.field_input type="text" field={f[:code]} label="Code" disabled={@live_action == :edit} />
            </div>
            <Forms.field_input type="textarea" field={f[:description]} label="Description" />
            <Forms.field_input type="text" field={f[:icon]} label="Icon" />

            <div class="grid grid-cols-3 gap-6">
              <Forms.field_input
                type="select"
                field={f[:type_id]}
                label="Type"
                options={@equipment_type_options}
              />
              <Forms.field_input type="select" field={f[:slot]} label="Slot" options={@slot_options} />
              <Forms.field_input type="number" field={f[:price]} label="Price" />
            </div>

            <Forms.fieldset legend="Stats">
              <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
                <Forms.field_input type="number" field={f[:max_health]} label="Max Health" />
                <Forms.field_input type="number" field={f[:max_energy]} label="Max Energy" />
                <Forms.field_input type="number" field={f[:physical_damage]} label="Physical Damage" />
                <Forms.field_input type="number" field={f[:magical_damage]} label="Magical Damage" />
                <Forms.field_input
                  type="number"
                  field={f[:physical_defense]}
                  label="Physical Defense"
                />
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
                <Forms.field_input type="number" field={f[:lehality]} label="Lehality" />
              </div>
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
    equipment_type_options = GEMS.Engine.Schema.EquipmentType.options()

    {:ok,
     assign(socket,
       equipment_type_options: equipment_type_options,
       slot_options: slot_options()
     )}
  end

  defp slot_options() do
    GEMS.Engine.Schema.Equipment
    |> Ecto.Enum.mappings(:slot)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end
end
