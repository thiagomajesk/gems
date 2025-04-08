defmodule GEMS.Database.Effects.ResourceRegen do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:resource, :amount]
  @optional []

  @primary_key false
  embedded_schema do
    field :resource, Ecto.Enum, values: [:health, :energy]
    field :amount, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
