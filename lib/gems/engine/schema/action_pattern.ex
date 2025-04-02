defmodule GEMS.Engine.Schema.ActionPattern do
  use GEMS.Database.Schema, preset: :default

  @conditions [
    :always,
    :random,
    :turn_number,
    :health_number,
    :energy_number,
    :state_presence,
    :state_absence
  ]

  @states GEMS.Engine.Constants.states()

  @required_fields [:priority, :condition]

  @optional_fields [
    :chance,
    :start_turn,
    :every_turn,
    :minimum_health,
    :maximum_health,
    :minimum_energy,
    :maximum_energy,
    :state,
    :skill_id
  ]

  schema "action_patterns" do
    field :priority, :integer
    field :condition, Ecto.Enum, values: @conditions

    field :chance, :float
    field :start_turn, :integer
    field :every_turn, :integer
    field :minimum_health, :integer
    field :maximum_health, :integer
    field :minimum_energy, :integer
    field :maximum_energy, :integer
    field :state, Ecto.Enum, values: @states

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
