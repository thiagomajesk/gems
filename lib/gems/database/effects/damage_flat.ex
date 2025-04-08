defmodule GEMS.Database.Effects.DamageFlat do
  use Ecto.Schema

  import Ecto.Changeset

  @damage_types GEMS.Engine.Constants.damage_types()
  @elements GEMS.Engine.Constants.elements()

  @required [:damage_type, :damage_max]
  @optional [:element, :damage_min]

  @primary_key false
  embedded_schema do
    field :element, Ecto.Enum, values: @elements, default: :neutral
    field :damage_type, Ecto.Enum, values: @damage_types
    field :damage_min, :integer, default: 1
    field :damage_max, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
