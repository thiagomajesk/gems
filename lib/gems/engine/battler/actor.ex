defmodule GEMS.Engine.Battler.Actor do
  alias __MODULE__

  @enforce_keys [:id, :party, :health, :mana]
  defstruct [
    :id,
    :party,
    :health,
    :mana,
    speed: 0,
    aggro: 0,
    charge: 0,
    armor_rating: 0,
    max_health: 0,
    health_regen: 0,
    attack_damage: 0,
    weapon_power: 0,
    evasion_rating: 0,
    attack_speed: 0,
    critical_rating: 0,
    accuracy_rating: 0,
    critical_power: 0,
    magic_resist: 0,
    max_mana: 0,
    mana_regen: 0,
    magic_damage: 0,
    skill_power: 0
  ]

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2
end
