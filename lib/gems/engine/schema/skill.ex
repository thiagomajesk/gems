defmodule GEMS.Engine.Schema.Skill do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id, :target_scope],
    optional_fields: [
      :action_cost,
      :description,
      :affinity,
      :repeats,
      :target_number,
      :random_targets,
      :critical_hits
    ],
    default_preloads: []

  @affinities GEMS.Engine.Constants.elements()
  @target_scopes GEMS.Engine.Constants.target_scopes()

  schema "skills" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :action_cost, :integer, default: 0
    field :affinity, Ecto.Enum, values: @affinities
    field :repeats, :integer, default: 1
    field :target_scope, Ecto.Enum, values: @target_scopes
    field :target_number, :integer, default: 1
    field :random_targets, :integer, default: 0
    field :critical_hits, :boolean, default: false

    belongs_to :type, GEMS.Engine.Schema.SkillType

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
    embeds_many :effects, GEMS.Engine.Battler.Effect, on_replace: :delete
  end

  def build_changeset(skill, attrs, opts) do
    changeset = super(skill, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> cast_embed(:effects)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
