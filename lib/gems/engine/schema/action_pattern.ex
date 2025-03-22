defmodule GEMS.Engine.Schema.ActionPattern do
  use GEMS.Database.Schema, preset: :default

  @types [:item, :skill]

  @conditions [
    :random,
    :always,
    :turn_number,
    :health_number,
    :mana_number,
    :state_presence,
    :item_presence,
    :skill_presence
  ]

  @required_fields [:name, :skill_id, :condition]

  @optional_fields [
    :description,
    :priority,
    :start_turn,
    :every_turn,
    :min_health,
    :max_health,
    :min_mana,
    :max_mana,
    :state_id
  ]

  embedded_schema do
    field :type, Ecto.Enum, values: @types
    field :priority, :integer

    field :condition, Ecto.Enum, values: @conditions

    field :chance, :float

    field :start_turn, :integer
    field :every_turn, :integer

    field :min_health, :integer
    field :max_health, :integer

    field :min_mana, :integer
    field :max_mana, :integer

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
