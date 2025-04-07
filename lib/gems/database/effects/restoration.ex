defmodule GEMS.Database.Effects.Restoration do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:health, :energy]
  @optional []

  @primary_key false
  embedded_schema do
    field :health, :integer
    field :energy, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
