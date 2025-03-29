defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.SkillComponent do
  use GEMSWeb, :live_component

  alias UI.Admin.Forms
  alias GEMSWeb.Admin.Database.CollectionLive.Forms.IconPickerComponent

  def render(assigns) do
    ~H"""
    <div id={"#{@id}-wrapper"}>
      <Forms.base_form :let={f} id={@id} for={@form} return_to={~p"/admin/database/"}>
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

            <.live_component module={IconPickerComponent} id="-icon" field={f[:icon]} label="Icon" />

            <div class="grid grid-cols-2 gap-6">
              <Forms.field_input type="number" field={f[:health_cost]} label="Health Cost" />
              <Forms.field_input type="number" field={f[:energy_cost]} label="Mana Cost" />
            </div>

            <div class="grid grid-cols-3 gap-6">
              <Forms.field_input
                type="select"
                field={f[:hit_type]}
                label="Hit Type"
                options={@hit_type_options}
              />
              <Forms.field_input type="percentage" field={f[:success_rate]} label="Success Rate" />
              <Forms.field_input type="number" field={f[:repeats]} label="Repeats" />
            </div>

            <Forms.field_input
              type="select"
              field={f[:type_id]}
              label="Type"
              options={@skill_types_options}
            />

            <Forms.fieldset legend="Target">
              <div class="grid grid-cols-2 gap-4">
                <Forms.field_input
                  type="select"
                  field={f[:target_side]}
                  label="Target Side"
                  options={@target_side_options}
                />

                <Forms.field_input
                  type="select"
                  field={f[:target_filter]}
                  label="Target Status"
                  options={@target_filter_options}
                />

                <Forms.field_input type="number" field={f[:target_number]} label="Target Number" />
                <Forms.field_input type="number" field={f[:random_targets]} label="Randon Targets" />
              </div>
            </Forms.fieldset>
          </div>
        </div>
      </Forms.base_form>
    </div>
    """
  end

  def mount(socket) do
    skill_types_options = GEMS.Engine.Schema.SkillType.options()

    {:ok,
     assign(socket,
       skill_types_options: skill_types_options,
       hit_type_options: hit_type_options(),
       target_side_options: target_side_options(),
       target_filter_options: target_filter_options()
     )}
  end

  defp hit_type_options() do
    GEMS.Engine.Schema.Skill
    |> Ecto.Enum.mappings(:hit_type)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end

  defp target_side_options() do
    GEMS.Engine.Schema.Skill
    |> Ecto.Enum.mappings(:target_side)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end

  defp target_filter_options() do
    GEMS.Engine.Schema.Skill
    |> Ecto.Enum.mappings(:target_filter)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end
end
