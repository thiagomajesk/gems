defmodule GEMS.Database.Effects.HealthRegen do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:amount]
  @optional []

  @primary_key false
  embedded_schema do
    field :amount, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
