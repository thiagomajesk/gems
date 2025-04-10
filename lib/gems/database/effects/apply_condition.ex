defmodule GEMS.Database.Effects.ApplyCondition do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:condition]
  @optional [:duration]

  @conditions GEMS.Engine.Constants.conditions()

  @primary_key false
  embedded_schema do
    field :condition, Ecto.Enum, values: @conditions
    field :duration, :integer, default: 1
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
