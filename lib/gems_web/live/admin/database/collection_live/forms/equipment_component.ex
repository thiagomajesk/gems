defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.EquipmentComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.TraitsAssocInput
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.SharedInputs

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/equipments"}>
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
          <div class="space-y-6">
            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input
                type="text"
                field={f[:name]}
                label="Name"
                phx-keyup={@live_action == :new && "code-hint"}
                phx-value-prefix={@live_action == :new && "equipment"}
              />
              <Forms.field_input
                type="text"
                field={f[:code]}
                label="Code"
                disabled={@live_action == :edit}
              />
            </div>
            <Forms.field_input type="textarea" field={f[:description]} label="Description" />
            <Forms.field_input type="text" field={f[:icon]} label="Icon" />

            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input
                type="select"
                field={f[:type_id]}
                label="Type"
                options={@equipment_type_options}
              />
              <Forms.field_input type="select" field={f[:slot]} label="Slot" options={@slot_options} />
              <Forms.field_input type="select" field={f[:tier]} label="Tier" options={@tier_options} />
              <Forms.field_input type="number" field={f[:price]} label="Price" />
            </div>

            <SharedInputs.stats_fieldset form={f} />
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
       slot_options: slot_options(),
       tier_options: tier_options()
     )}
  end

  defp slot_options() do
    GEMS.Engine.Schema.Equipment
    |> Ecto.Enum.mappings(:slot)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end

  def tier_options() do
    GEMS.Engine.Schema.Equipment
    |> Ecto.Enum.mappings(:tier)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end
end
