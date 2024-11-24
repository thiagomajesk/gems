defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.EquipmentTypeComponent do
  use GEMSWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <UI.Admin.Forms.base_form
        :let={f}
        id={@id}
        for={@form}
        return_to={~p"/admin/database/equipment-types"}
      >
        <UI.Admin.Forms.field_input type="text" field={f[:name]} label="Name" />
        <UI.Admin.Forms.field_input type="textarea" field={f[:description]} label="Description" />
      </UI.Admin.Forms.base_form>
    </div>
    """
  end
end
