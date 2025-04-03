defmodule GEMS.Database.Effects.ActionCost do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:type, :cost]
  @optional []

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: [:health, :energy]
    field :amount, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
