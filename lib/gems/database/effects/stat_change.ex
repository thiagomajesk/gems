defmodule GEMS.Database.Effects.StatChange do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:stat, :value, :assessment]
  @optional [:duration]

  @stats GEMS.Engine.Constants.statistics()

  @primary_key false
  embedded_schema do
    field :stat, Ecto.Enum, values: @stats
    field :value, :float
    field :assessment, Ecto.Enum, values: [:buff, :debuff]
    field :duration, :integer, default: 1
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
