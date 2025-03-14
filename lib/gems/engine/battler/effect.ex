defmodule GEMS.Engine.Battler.Effect do
  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  defstruct [:type, :metadata]

  def commit_effect(%Actor{} = target, %Effect{type: :damage} = effect) do
    Map.update!(target, :health, &max(&1 - effect.metadata.amount, 0))
  end

  def commit_effect(%Actor{} = target, %Effect{type: :health_regen} = effect) do
    Map.update!(target, :health, &min(&1 + effect.metadata.amount, target.max_health))
  end

  def commit_effect(%Actor{} = target, %Effect{type: :mana_regen} = effect) do
    Map.update!(target, :mana, &min(&1 + effect.metadata.amount, target.max_mana))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :damage} = effect) do
    Map.update!(target, :health, &min(&1 + effect.metadata.amount, target.max_health))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :health_regen} = effect) do
    Map.update!(target, :health, &max(&1 - effect.metadata.amount, 0))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :mana_regen} = effect) do
    Map.update!(target, :mana, &max(&1 - effect.metadata.amount, 0))
  end
end
