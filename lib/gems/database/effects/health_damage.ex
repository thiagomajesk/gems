defmodule GEMS.Database.Effects.HealthDamage do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:damage_amount, :target_filter, :damage_type, :target_side]
  @optional [:target_number]

  @primary_key false
  embedded_schema do
    field :damage_amount, :integer
    field :target_number, :integer, default: 1
    field :target_filter, Ecto.Enum, values: [:alive, :dead]
    field :damage_type, Ecto.Enum, values: GEMS.Engine.Constants.damage_types()
    field :target_side, Ecto.Enum, values: GEMS.Engine.Constants.target_sides()
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
