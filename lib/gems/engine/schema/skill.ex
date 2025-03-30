defmodule GEMS.Engine.Schema.Skill do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id],
    optional_fields: [
      :description,
      :health_cost,
      :energy_cost,
      :target_side,
      :target_filter,
      :target_number,
      :random_targets,
      :hit_type,
      :affinity,
      :success_rate,
      :repeats
    ],
    default_preloads: []

  @affinities GEMS.Engine.Constants.elements()
  @hit_types GEMS.Engine.Constants.hit_types()
  @target_sides GEMS.Engine.Constants.target_sides()

  schema "skills" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :health_cost, :integer, default: 0
    field :energy_cost, :integer, default: 0

    field :repeats, :integer, default: 1
    field :target_side, Ecto.Enum, values: @target_sides
    field :target_filter, Ecto.Enum, values: [:alive, :dead]
    field :target_number, :integer, default: 1
    field :random_targets, :integer, default: 0
    field :success_rate, :float, default: 1.0

    field :hit_type, Ecto.Enum, values: @hit_types
    field :affinity, Ecto.Enum, values: @affinities

    field :effects, {:array, :map}, default: []

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
