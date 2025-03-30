defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__

  @parties [:alpha, :bravo, :charlie, :delta]
  @states GEMS.Engine.Constants.states()

  embedded_schema do
    field :party, Ecto.Enum, values: @parties
    field :health, :integer, default: 0
    field :energy, :integer, default: 0
    field :aggro, :integer, default: 0
    field :charge, :integer, default: 0

    field :states, {:array, Ecto.Enum}, values: @states, virtual: true

    field :maximum_health, :integer, virtual: true
    field :maximum_energy, :integer, virtual: true
    field :health_regeneration, :integer, virtual: true
    field :energy_regeneration, :integer, virtual: true
    field :physical_armor, :integer, virtual: true
    field :magical_armor, :integer, virtual: true
    field :attack_speed, :integer, virtual: true
    field :accuracy_rating, :integer, virtual: true
    field :evasion_rating, :integer, virtual: true
    field :critical_rating, :integer, virtual: true
    field :recovery_rating, :integer, virtual: true
    field :fortitude_rating, :integer, virtual: true
    field :damage_penetration, :integer, virtual: true
    field :damage_reflection, :integer, virtual: true

    # Resistances
    field :fire_resistance, :integer, virtual: true
    field :water_resistance, :integer, virtual: true
    field :earth_resistance, :integer, virtual: true
    field :air_resistance, :integer, virtual: true

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
