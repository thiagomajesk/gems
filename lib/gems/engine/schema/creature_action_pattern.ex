defmodule GEMS.Engine.Schema.CreatureActionPattern do
  use Ecto.Schema
  import Ecto.Changeset

  @conditions [
    :always,
    :turn_number,
    :health_number,
    :energy_number
  ]

  @required_fields [:name, :ability_id, :condition]
  @optional_fields [
    :description,
    :priority,
    :min_turn,
    :max_turn,
    :min_health,
    :max_health,
    :min_energy,
    :max_energy,
    :state_id
  ]

  schema "action_patterns" do
    field :name, :string
    field :description, :string
    field :priority, :integer
    field :condition, Ecto.Enum, values: @conditions
    field :min_turn, :integer
    field :max_turn, :integer
    field :min_health, :integer
    field :max_health, :integer
    field :min_energy, :integer
    field :max_energy, :integer

    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :ability, GEMS.Engine.Schema.Ability
    belongs_to :state, GEMS.Engine.Schema.State
  end

  @doc false
  def changeset(action_pattern, attrs) do
    action_pattern
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ability)
    |> assoc_constraint(:state)
  end
end
