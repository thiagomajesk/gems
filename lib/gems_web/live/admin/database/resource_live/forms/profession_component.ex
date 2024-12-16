defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.ProfessionComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/professions"}>
        <div class="grid grid-cols-2 gap-6">
          <Forms.field_input
            type="text"
            field={f[:name]}
            label="Name"
            phx-keyup={@live_action == :new && "code-hint"}
            phx-value-prefix={@live_action == :new && "profession"}
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
        <Forms.field_input
          type="select"
          field={f[:type]}
          label="Type"
          options={@profession_type_options}
        />
      </Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, profession_type_options: profession_type_options())}
  end

  defp profession_type_options() do
    GEMS.Engine.Schema.Profession
    |> Ecto.Enum.mappings(:type)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end
end
