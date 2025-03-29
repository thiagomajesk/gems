defmodule GEMS.Engine.Schema.ActionPattern do
  use GEMS.Database.Schema, preset: :default

  @kinds [:skill, :item]

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

  @required_fields [:kind, :priority, :condition]

  @optional_fields [
    :chance,
    :start_turn,
    :every_turn,
    :min_health,
    :max_health,
    :min_energy,
    :max_energy,
    :item_id,
    :skill_id,
    :state_id
  ]

  schema "action_patterns" do
    field :kind, Ecto.Enum, values: @kinds
    field :condition, Ecto.Enum, values: @conditions
    field :priority, :integer

    field :chance, :float

    field :start_turn, :integer
    field :every_turn, :integer

    field :min_health, :integer
    field :max_health, :integer

    field :min_energy, :integer
    field :max_energy, :integer

    belongs_to :item, GEMS.Engine.Schema.Item
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
