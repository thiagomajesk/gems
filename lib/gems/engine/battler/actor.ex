defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__

  @parties [:alpha, :bravo, :charlie, :delta]

  embedded_schema do
    field :party, Ecto.Enum, values: @parties
    field :health, :integer, default: 0
    field :energy, :integer, default: 0
    field :aggro, :integer, default: 0
    field :charge, :integer, default: 0

    field :armor_rating, :integer, default: 0
    field :max_health, :integer, default: 0
    field :health_regen, :integer, default: 0
    field :attack_damage, :integer, default: 0
    field :attack_power, :integer, default: 0

    field :evasion_rating, :integer, default: 0
    field :attack_speed, :integer, default: 0
    field :critical_rating, :integer, default: 0
    field :accuracy_rating, :integer, default: 0
    field :critical_power, :integer, default: 0

    field :magic_resist, :integer, default: 0
    field :max_energy, :integer, default: 0
    field :energy_regen, :integer, default: 0
    field :magic_damage, :integer, default: 0
    field :magic_power, :integer, default: 0

    # Current effects
    field :buffs, {:array, :map}, default: []
    field :debuffs, {:array, :map}, default: []

    field :action_patterns, {:array, :map}, default: [], virtual: true
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2

  def commit_effect(%Actor{} = actor, _effect) do
    actor
  end

  def revert_effect(%Actor{} = actor, _effect) do
    actor
  end

  def commit_state(%Actor{} = actor, _state) do
    actor
  end

  def revert_state(%Actor{} = actor, _state) do
    actor
  end
end
