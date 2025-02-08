defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.CreatureComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.TraitsAssocInput
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.SharedInputs

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/creatures"}>
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
    biome_options = GEMS.Engine.Schema.Biome.options()
    type_options = GEMS.Engine.Schema.CreatureType.options()

    {:ok,
     socket
     |> assign(:biome_options, biome_options)
     |> assign(:type_options, type_options)}
  end
end
