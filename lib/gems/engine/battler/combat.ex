defmodule GEMS.Engine.Battler.Combat do
  alias GEMS.Engine.Battler.Actor

  def hit_chance(%Actor{} = attacker, %Actor{} = defender) do
    value = 0.5 + (attacker.accuracy - defender.evasion) * 0.01
    clamp(value, 0.10, 0.95)
  end

  def dodge_chance(defender) do
    value = defender.evasion * 0.005
    clamp(value, 0.05, 0.50)
  end

  def crit_chance(attacker) do
    value = attacker.critical_chance
    clamp(value, 0.05, 0.50)
  end

  def outcome(attacker, defender) do
    hit_chance = hit_chance(attacker, defender)
    dodge_chance = dodge_chance(defender)
    crit_chance = crit_chance(attacker)

    hit_roll = :rand.uniform()
    dodge_roll = :rand.uniform()
    crit_roll = :rand.uniform()

    case {hit_roll, dodge_roll, crit_roll} do
      {hit_roll, _dr, _cr} when hit_roll < hit_chance -> :miss
      {_hr, dodge_roll, _cr} when dodge_roll < dodge_chance -> :dodge
      {_hr, _dr, crit_roll} when crit_roll < crit_chance -> :crit
      {_hr, _dr, _cr} -> :hit
    end
  end

  defp clamp(value, min, _max) when value < min, do: min
  defp clamp(value, _min, max) when value > max, do: max
  defp clamp(value, _min, _max), do: value
end
