defmodule GEMS.Engine.Schema.ActionPattern do
  use GEMS.Database.Schema, preset: :default

  @types [:skill, :item]

  @conditions [
    :always,
    :random,
    :turn_number,
    :health_number,
    :energy_number,
    :state_presence,
    :item_presence,
    :skill_presence
  ]

  @states GEMS.Engine.Constants.states()

  @required_fields [:kind, :priority, :condition]

  @optional_fields [
    :chance,
    :start_turn,
    :every_turn,
    :min_health,
    :maximum_health,
    :min_energy,
    :maximum_energy,
    :state,
    :item_id,
    :skill_id
  ]

  schema "action_patterns" do
    field :type, Ecto.Enum, values: @types
    field :condition, Ecto.Enum, values: @conditions
    field :priority, :integer

    field :chance, :float

    field :start_turn, :integer
    field :every_turn, :integer

    field :min_health, :integer
    field :maximum_health, :integer

    field :min_energy, :integer
    field :maximum_energy, :integer

    field :state, Ecto.Enum, values: @states

    belongs_to :item, GEMS.Engine.Schema.Item
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
