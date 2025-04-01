defmodule GEMS.Engine.Schema.Skill do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id, :target_side],
    optional_fields: [
      :description,
      :health_cost,
      :energy_cost,
      :affinity,
      :target_number,
      :random_targets,
      :effects
    ],
    default_preloads: []

  @affinities GEMS.Engine.Constants.elements()
  @target_sides GEMS.Engine.Constants.target_sides()

  schema "skills" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :health_cost, :integer, default: 0
    field :energy_cost, :integer, default: 0
    field :affinity, Ecto.Enum, values: @affinities
    field :target_side, Ecto.Enum, values: @target_sides
    field :target_number, :integer, default: 1
    field :random_targets, :integer, default: 0

    field :effects, {:array, GEMS.Database.Dynamic},
      types: GEMS.Engine.Constants.effect_types_mappings(),
      default: []

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    belongs_to :type, GEMS.Engine.Schema.SkillType
  end

  def build_changeset(skill, attrs, opts) do
    changeset = super(skill, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
