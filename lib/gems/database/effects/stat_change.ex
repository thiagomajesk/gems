defmodule GEMS.Database.Effects.StatChange do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:stat, :change, :assessment]
  @optional [:duration]

  @stats GEMS.Engine.Constants.statistics()
  @assessments [:positive, :negative]

  @primary_key false
  embedded_schema do
    field :stat, Ecto.Enum, values: @stats
    field :change, :float
    field :assessment, Ecto.Enum, values: @assessments
    field :duration, :integer, default: 1
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
