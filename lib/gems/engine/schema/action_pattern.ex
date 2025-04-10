defmodule GEMS.Engine.Schema.ActionPattern do
  use GEMS.Database.Schema, preset: :default

  @optional_fields [
    :chance,
    :start_turn,
    :every_turn,
    :minimum_health,
    :maximum_health,
    :minimum_action_points,
    :maximum_action_points,
    :condition,
    :skill_id
  ]

  @required_fields [:priority, :trigger]

  @triggers GEMS.Engine.Constants.triggers()
  @conditions GEMS.Engine.Constants.conditions()

  schema "action_patterns" do
    field :priority, :integer
    field :trigger, Ecto.Enum, values: @triggers

    field :chance, :float
    field :start_turn, :integer
    field :every_turn, :integer
    field :minimum_health, :integer
    field :maximum_health, :integer
    field :minimum_action_points, :integer
    field :maximum_action_points, :integer
    field :condition, Ecto.Enum, values: @conditions

    belongs_to :skill, GEMS.Engine.Schema.Skill
  end

  @doc false
  def changeset(action_pattern, attrs) do
    action_pattern
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:skill)
  end
end
