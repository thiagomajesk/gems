defmodule GEMS.Engine.Schema.State do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:description, :icon, :priority, :restriction]

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
    field :priority, :integer
    field :restriction, Ecto.Enum, values: @restrictions
  end

  def changeset(state, attrs) do
    state
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:priority, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
  end
end
