defmodule GEMS.Engine.Schema.State do
  use GEMS.Database.Schema, :resource

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
    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
  end

  def changeset(state, attrs) do
    state
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> validate_required(@required_fields)
    |> validate_number(:priority, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
  end
end
