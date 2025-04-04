defmodule GEMS.Engine.Battler.Effect do
  alias GEMS.Database.Effects.HealthRegen
  alias GEMS.Database.Effects.HealthDrain
  alias GEMS.Database.Effects.ApplyStatus
  alias GEMS.Database.Effects.ActionCost
  alias GEMS.Database.Effects.HealthDamage
  alias GEMS.Database.Effects.PassiveRegen

  def apply_effect(%ActionCost{} = effect, _source, target) do
    target
    |> Map.update!(:health, &(&1 - effect.health))
    |> Map.update!(:energy, &(&1 - effect.energy))
  end

  def apply_effect(%PassiveRegen{} = effect, _source, target) do
    target
    |> Map.update!(:health, &(&1 + effect.health))
    |> Map.update!(:energy, &(&1 + effect.energy))
  end

  def apply_effect(%HealthDamage{} = effect, _source, target) do
    Map.update!(target, :health, &(&1 - effect.damage_amount))
  end

  def apply_effect(%HealthRegen{} = effect, _source, target) do
    Map.update!(target, :health, &(&1 + effect.amount))
  end

  def apply_effect(%HealthDrain{} = effect, source, target) do
    source = Map.update!(source, :health, &(&1 + effect.amount))
    target = Map.update!(target, :health, &(&1 - effect.amount))
    {source, target}
  end

  def apply_effect(%ApplyStatus{} = _effect, _source, target), do: target

  def apply_effect(other_effect, _source, _target),
    do: raise("Unknown effect type: #{inspect(other_effect)}")
end
