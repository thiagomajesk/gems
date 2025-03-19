defmodule GEMS.Engine.Schema.CreatureActionPattern do
  use GEMS.Database.Schema, preset: :default

  @conditions [
    :always,
    :turn_number,
    :health_number,
    :mana_number
  ]

  @required_fields [:name, :skill_id, :condition]

  @optional_fields [
    :description,
    :priority,
    :min_turn,
    :max_turn,
    :min_health,
    :max_health,
    :min_mana,
    :max_mana,
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
    field :min_mana, :integer
    field :max_mana, :integer

    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :skill, GEMS.Engine.Schema.Skill
    belongs_to :state, GEMS.Engine.Schema.State
  end

  @doc false
  def changeset(action_pattern, attrs) do
    action_pattern
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:skill)
    |> assoc_constraint(:state)
  end
end
