defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.ProfessionComponent do
  use GEMSWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <UI.Admin.Forms.base_form
        :let={f}
        id={@id}
        for={@form}
        return_to={~p"/admin/database/professions"}
      >
        <UI.Admin.Forms.field_input type="text" field={f[:name]} label="Name" />
        <UI.Admin.Forms.field_input type="textarea" field={f[:description]} label="Description" />
        <UI.Admin.Forms.field_input type="text" field={f[:icon]} label="Icon" />
        <UI.Admin.Forms.field_input
          type="select"
          field={f[:type]}
          label="Type"
          options={@profession_type_options}
        />
      </UI.Admin.Forms.base_form>
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
