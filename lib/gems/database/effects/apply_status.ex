defmodule GEMS.Database.Effects.ApplyStatus do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:target_filter, :target_side]
  @optional [:target_number]

  @primary_key false
  embedded_schema do
    field :target_number, :integer, default: 1
    field :target_filter, Ecto.Enum, values: [:alive, :dead]
    field :target_side, Ecto.Enum, values: GEMS.Engine.Constants.target_sides()
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
