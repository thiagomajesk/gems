defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.ClassComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.ProgressCurveComponent
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.TraitsAssocInput

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/classes"}>
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

            <Forms.fieldset legend="Curves">
              <.live_component
                module={ProgressCurveComponent}
                id="strength-curve"
                field={f[:strength_curve]}
                label="Strength"
              />
              <.live_component
                module={ProgressCurveComponent}
                id="dexterity-curve"
                field={f[:dexterity_curve]}
                label="Dexterity"
              />
              <.live_component
                module={ProgressCurveComponent}
                id="intelligence-curve"
                field={f[:intelligence_curve]}
                label="Intelligence"
              />
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
    blessing_options = GEMS.World.Schema.Blessing.options()
    {:ok, assign(socket, :blessing_options, blessing_options)}
  end
end
