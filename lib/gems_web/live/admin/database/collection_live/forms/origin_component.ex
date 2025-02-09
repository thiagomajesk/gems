defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.OriginComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.FileExplorerComponent

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/origins"}>
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
          <div class="space-y-6">
            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input
                type="text"
                field={f[:name]}
                label="Name"
                phx-keyup={@live_action == :new && "code-hint"}
              />
              <Forms.field_input
                type="text"
                field={f[:code]}
                label="Code"
                disabled={@live_action == :edit}
              />
            </div>
            <Forms.field_input type="textarea" field={f[:description]} label="Description" />

            <div class="grid grid-cols-3 gap-6">
              <Forms.field_input type="number" field={f[:strength]} label="Strength" />
              <Forms.field_input type="number" field={f[:dexterity]} label="Dexterity" />
              <Forms.field_input type="number" field={f[:intelligence]} label="Intelligence" />
            </div>

            <Forms.field_input
              type="select"
              field={f[:blessing_id]}
              label="Blessing"
              options={@blessing_options}
            />

            <.live_component
              module={FileExplorerComponent}
              extensions={["png", "jpg", "jpeg"]}
              id="origin-icon"
              directory="origins"
              field={f[:icon]}
              label="Icon"
            />
          </div>
        </div>
      </Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    blessing_options = GEMS.World.Schema.Blessing.options()
    {:ok, assign(socket, :blessing_options, blessing_options)}
  end
end
