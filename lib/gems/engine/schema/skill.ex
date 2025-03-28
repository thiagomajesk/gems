defmodule GEMS.Engine.Schema.Skill do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id],
    optional_fields: [
      :description,
      :health_cost,
      :mana_cost,
      :target_side,
      :target_status,
      :target_number,
      :random_targets,
      :hit_type,
      :success_rate,
      :repeats,
      :damage_type,
      :damage_formula,
      :damage_variance,
      :critical_hits,
      :messages,
      :damage_element_id
    ],
    default_preloads: []

  @hit_types GEMS.Engine.Constants.hit_types()
  @target_sides GEMS.Engine.Constants.target_sides()
  @damage_types GEMS.Engine.Constants.damage_types()

  schema "skills" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :messages, :map, default: %{}
    field :health_cost, :integer, default: 0
    field :mana_cost, :integer, default: 0

    field :target_side, Ecto.Enum, values: @target_sides
    field :target_status, Ecto.Enum, values: [:alive, :dead]
    field :target_number, :integer, default: 1
    field :random_targets, :integer, default: 0

    field :hit_type, Ecto.Enum, values: @hit_types
    field :success_rate, :float, default: 1.0
    field :repeats, :integer, default: 1

    field :damage_type, Ecto.Enum, values: @damage_types
    field :damage_formula, :string
    field :damage_variance, :float, default: 0.0
    field :critical_hits, :boolean, default: true

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    belongs_to :type, GEMS.Engine.Schema.SkillType
    belongs_to :damage_element, GEMS.Engine.Schema.Element
  end

  def build_changeset(skill, attrs, opts) do
    changeset = super(skill, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
