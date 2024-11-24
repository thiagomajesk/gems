defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.BiomeComponent do
  use GEMSWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <UI.Admin.Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/biomes"}>
        <UI.Admin.Forms.field_input type="text" field={f[:name]} label="Name" />
        <UI.Admin.Forms.field_input type="textarea" field={f[:description]} label="Description" />

        <div class="grid grid-cols-2 gap-6">
          <UI.Admin.Forms.field_input
            type="select"
            field={f[:affinity_id]}
            label="Affinity"
            options={@elements_options}
          />
          <UI.Admin.Forms.field_input
            type="select"
            field={f[:aversion_id]}
            label="Aversion"
            options={@elements_options}
          />
        </div>
      </UI.Admin.Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    elements_options = GEMS.Engine.Schema.Element.options()
    {:ok, assign(socket, :elements_options, elements_options)}
  end
end
