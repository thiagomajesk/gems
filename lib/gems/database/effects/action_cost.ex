defmodule GEMS.Database.Effects.ActionCost do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:health_cost, :energy_cost]
  @optional []

  @primary_key false
  embedded_schema do
    field :health_cost, :integer
    field :energy_cost, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
