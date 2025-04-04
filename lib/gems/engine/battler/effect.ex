defmodule GEMS.Engine.Battler.Effect do
  alias GEMS.Database.Effects.ApplyStatus
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Database.Effects.ActionCost
  alias GEMS.Database.Effects.HealthDamage
  alias GEMS.Database.Effects.PassiveRegen

  def apply_effect(%ActionCost{} = effect, %Actor{} = target) do
    target
    |> Map.update!(:health, &(&1 - effect.health))
    |> Map.update!(:energy, &(&1 - effect.energy))
  end

  def apply_effect(%PassiveRegen{} = effect, %Actor{} = target) do
    target
    |> Map.update!(:health, &(&1 + effect.health))
    |> Map.update!(:energy, &(&1 + effect.energy))
  end

  def apply_effect(%HealthDamage{} = effect, %Actor{} = target) do
    Map.update!(target, :health, &(&1 - effect.damage_amount))
  end

  def apply_effect(%ApplyStatus{} = _effect, %Actor{} = target), do: target

  def apply_effect(other_effect, _target),
    do: raise("Unknown effect type: #{inspect(other_effect)}")
end
