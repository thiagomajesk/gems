defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.BlessingComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.IconPickerComponent

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/blessings"}>
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

          <Forms.field_input type="text" field={f[:duration]} label="Duration" />

          <.live_component
            module={IconPickerComponent}
            id="-icon"
            field={f[:icon]}
            label="Icon"
          />
        </div>
      </Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
