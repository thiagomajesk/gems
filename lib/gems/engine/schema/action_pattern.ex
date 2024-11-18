defmodule GEMS.Engine.Schema.ActionPattern do
  use Ecto.Schema
  import Ecto.Changeset

  schema "action_patterns" do
    field :name, :string
    field :description, :string
    belongs_to :ability, GEMS.Engine.Schema.Ability
    field :priority, :integer, default: 0
    field :condition, :string
    field :min_turn, :integer
    field :max_turn, :integer
    field :min_health, :integer
    field :max_health, :integer
    field :min_energy, :integer
    field :max_energy, :integer
    belongs_to :state, GEMS.Engine.Schema.State
  end

  @doc false
  def changeset(action_pattern, attrs) do
    action_pattern
    |> cast(attrs, [
      :name,
      :description,
      :ability_id,
      :priority,
      :condition,
      :min_turn,
      :max_turn,
      :min_health,
      :max_health,
      :min_energy,
      :max_energy,
      :state_id
    ])
    |> validate_required([:name, :ability_id, :condition])
    |> assoc_constraint(:ability)
    |> assoc_constraint(:state)
  end
end
