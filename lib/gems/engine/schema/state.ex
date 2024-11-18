defmodule GEMS.Engine.Schema.State do
  use Ecto.Schema
  import Ecto.Changeset

  @restrictions [
    :attack_enemy,
    :attack_ally,
    :attack_anyone,
    :cannot_attack
  ]

  schema "states" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :priority, :integer, default: 100
    field :restriction, Ecto.Enum, values: @restrictions
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:name, :description, :icon, :priority, :restriction])
    |> validate_required([:name])
    |> validate_number(:priority, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
  end
end
