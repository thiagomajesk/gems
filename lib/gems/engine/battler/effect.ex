defmodule GEMS.Engine.Battler.Effect do
  use Ecto.Schema

  import Ecto.Changeset

  alias GEMS.Engine.Battler.Actor
  alias GEMS.Database.Effects.HealthRegen
  alias GEMS.Database.Effects.HealthDrain
  alias GEMS.Database.Effects.ApplyCondition
  alias GEMS.Database.Effects.StatChange
  alias GEMS.Database.Effects.ActionCost
  alias GEMS.Database.Effects.HealthDamage
  alias GEMS.Database.Effects.PassiveRegen

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
  end

  def changeset(effect, attrs) do
    effect
    |> cast(attrs, [:chance, :target, :on_hit, :on_miss, :on_crit])
    |> validate_required([:chance, :target])
  end

  def apply_effect(%ActionCost{} = effect, _caster, target) do
    target
    |> Map.update!(:health, &(&1 - effect.health))
    |> Map.update!(:energy, &(&1 - effect.energy))
  end

  def apply_effect(%PassiveRegen{} = effect, _caster, target) do
    target
    |> Actor.change_health(effect.health)
    |> Actor.change_energy(effect.energy)
  end

  def apply_effect(%HealthDamage{} = effect, _caster, target) do
    %{damage_max: max, damage_min: min} = effect
    damage = :rand.uniform(max - min + 1) + min - 1
    Actor.change_health(target, -damage)
  end

  def apply_effect(%HealthRegen{} = effect, _caster, target) do
    Actor.change_health(target, effect.amount)
  end

  def apply_effect(%HealthDrain{} = effect, caster, target) do
    {
      Actor.change_health(caster, effect.amount),
      Actor.change_health(target, -effect.amount)
    }
  end

  def apply_effect(%ApplyCondition{} = _effect, _caster, target), do: target
  def apply_effect(%StatChange{} = _effect, _caster, target), do: target

  def apply_effect(other_effect, _caster, _target),
    do: raise("Unknown effect type: #{inspect(other_effect)}")
end
