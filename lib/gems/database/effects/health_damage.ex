defmodule GEMS.Database.Effects.HealthDamage do
  use Ecto.Schema

  import Ecto.Changeset

  @damage_types GEMS.Engine.Constants.damage_types()
  @target_scopes GEMS.Engine.Constants.target_scopes()

  @required [:target_scope, :damage_type, :damage_amount]
  @optional []

  @primary_key false
  embedded_schema do
    field :target_scope, Ecto.Enum, values: @target_scopes
    field :damage_type, Ecto.Enum, values: @damage_types
    field :damage_amount, :integer
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
