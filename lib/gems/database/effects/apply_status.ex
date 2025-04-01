defmodule GEMS.Database.Effects.ApplyStatus do
  use Ecto.Schema

  import Ecto.Changeset

  @target_scopes GEMS.Engine.Constants.target_scopes()

  @required [:target_scope]
  @optional [:chance, :stacks]

  @primary_key false
  embedded_schema do
    field :target_scope, Ecto.Enum, values: @target_scopes
    field :chance, :float, default: 1.0
    field :stacks, :integer, default: 1
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
