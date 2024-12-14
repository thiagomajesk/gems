defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.EquipmentTypeComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/equipment-types"}>
        <div class="grid grid-cols-2 gap-6">
          <Forms.field_input type="text" field={f[:name]} label="Name" />
          <Forms.field_input type="text" field={f[:code]} label="Code" />
        </div>
        <Forms.field_input type="textarea" field={f[:description]} label="Description" />
      </Forms.base_form>
    </div>
    """
  end
end
