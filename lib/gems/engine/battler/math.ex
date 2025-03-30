defmodule GEMS.Engine.Battler.Math do
  alias GEMS.Engine.Battler.Actor

  def hit_chance(%Actor{} = attacker, %Actor{} = defender) do
    accuracy_ratio = attacker.accuracy_rating / defender.evasion_rating
    0.5 + :math.atan(accuracy_ratio - 1) / :math.pi()
  end

  def critical_chance(%Actor{} = attacker, %Actor{} = defender) do
    crit_ratio = attacker.critical_rating / (1 + defender.evasion_rating / 2)
    0.1 + (0.6 - 0.1) / (1 + :math.exp(-crit_ratio))
  end

  def critical_damage(%Actor{} = attacker, damage) do
    critical_power_ratio = attacker.critical_power / 100
    round(damage * 1.5 / (1 + :math.exp(-critical_power_ratio)))
  end

  def physical_damage(%Actor{} = attacker, %Actor{} = defender) do
    damage =
      damage(
        attacker.physical_damage,
        defender.evasion_rating
      )

    round(damage * (1 + attacker.physical_power / 100))
  end

  def magical_damage(%Actor{} = attacker, %Actor{} = defender) do
    damage =
      damage(
        attacker.magical_damage,
        defender.magical_resistance
      )

    round(damage * (1 + attacker.magical_power / 100))
  end

  def health_regeneration(%Actor{} = actor) do
    base_regen = 0.02 + 0.02 * :rand.uniform()
    regen_ratio = actor.health_regeneration / actor.maximum_health
    scaled_regen = 0.8 * (1 - :math.exp(-regen_ratio))
    round((scaled_regen + base_regen) * actor.maximum_health)
  end

  def energy_regeneration(%Actor{} = actor) do
    base_regen = 0.04 + 0.04 * :rand.uniform()
    regen_ratio = actor.energy_regeneration / actor.maximum_energy
    scaled_regen = 0.8 * (1 - :math.exp(-regen_ratio))
    round((scaled_regen + base_regen) * actor.maximum_energy)
  end

  defp damage(damage, defense) do
    damage_ratio = damage / (damage + defense / 0.1 - defense)
    base_damage = round(damage * damage_ratio)
    damage_variance = 0.2 + 0.8 * :rand.uniform()
    max(1, round(base_damage * damage_variance))
  end
end
