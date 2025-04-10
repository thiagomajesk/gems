defmodule GEMS.Engine.Battler.Effect do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @required_fields [:chance, :target]
  @optional_fields [:on_hit, :on_miss, :on_crit, :on_dodge]

  @targets [
    :caster,
    :target,
    :caster_group_inclusive,
    :caster_group_exclusive,
    :target_group_inclusive,
    :target_group_exclusive
  ]

  @effect_types_mappings GEMS.Engine.Constants.effect_types_mappings()

  @primary_key false
  embedded_schema do
    field :chance, :float, default: 1.0
    field :target, Ecto.Enum, values: @targets

    field :on_hit, GEMS.Database.Dynamic, types: @effect_types_mappings
    field :on_miss, GEMS.Database.Dynamic, types: @effect_types_mappings
    field :on_crit, GEMS.Database.Dynamic, types: @effect_types_mappings
    field :on_dodge, GEMS.Database.Dynamic, types: @effect_types_mappings
    field :on_token, GEMS.Database.Dynamic, types: @effect_types_mappings
    field :on_action, GEMS.Database.Dynamic, types: @effect_types_mappings
  end

  def changeset(effect, attrs) do
    effect
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def fetch_effect(%Effect{} = effect, :hit), do: effect.on_hit
  def fetch_effect(%Effect{} = effect, :miss), do: effect.on_miss
  def fetch_effect(%Effect{} = effect, :crit), do: effect.on_crit
  def fetch_effect(%Effect{} = effect, :dodge), do: effect.on_dodge
end
