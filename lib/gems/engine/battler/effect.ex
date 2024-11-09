defmodule GEMS.Engine.Battler.Effect do
  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  defstruct [:type, :metadata]

  def commit_effect(%Actor{} = target, %Effect{type: :damage} = effect) do
    Map.update!(target, :__health__, &max(&1 - effect.metadata.amount, 0))
  end

  def commit_effect(%Actor{} = target, %Effect{type: :health_regen} = effect) do
    Map.update!(target, :__health__, &min(&1 + effect.metadata.amount, &1.max_health))
  end

  def commit_effect(%Actor{} = target, %Effect{type: :energy_regen} = effect) do
    Map.update!(target, :__energy__, &min(&1 + effect.metadata.amount, &1.max_energy))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :damage} = effect) do
    Map.update!(target, :__health__, &min(&1 + effect.metadata.amount, &1.max_health))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :health_regen} = effect) do
    Map.update!(target, :__health__, &max(&1 - effect.metadata.amount, 0))
  end

  def revert_effect(%Actor{} = target, %Effect{type: :energy_regen} = effect) do
    Map.update!(target, :__energy__, &max(&1 - effect.metadata.amount, 0))
  end
end
