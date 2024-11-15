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
        attacker.break_power,
        defender.physical_defense
      )

    round(damage * (1 + attacker.weapon_power / 100))
  end

  def magical_damage(%Actor{} = attacker, %Actor{} = defender) do
    damage =
      damage(
        attacker.magical_damage,
        attacker.break_power,
        defender.magical_defense
      )

    round(damage * (1 + attacker.ability_power / 100))
  end

  def health_regen(%Actor{} = actor) do
    base_regen = 0.02 + 0.02 * :rand.uniform()
    regen_ratio = actor.health_regen / actor.max_health
    scaled_regen = 0.8 * (1 - :math.exp(-regen_ratio))
    round((scaled_regen + base_regen) * actor.max_health)
  end

  def energy_regen(%Actor{} = actor) do
    base_regen = 0.04 + 0.04 * :rand.uniform()
    regen_ratio = actor.energy_regen / actor.max_energy
    scaled_regen = 0.8 * (1 - :math.exp(-regen_ratio))
    round((scaled_regen + base_regen) * actor.max_energy)
  end

  defp damage(damage, break_power, defense) do
    damage_ratio = damage / (damage + defense / 0.1 - defense)
    base_damage = round(damage * damage_ratio)
    damage_variance = 0.2 + 0.8 * :rand.uniform()
    stance_break_ratio = break_power / (break_power + defense)
    stance_break_bonus = stance_break_ratio * 0.2 * damage
    stance_break_variance = 0.4 + 0.6 * :rand.uniform()
    stance_damage = stance_break_bonus * stance_break_variance
    max(1, round(base_damage * damage_variance + stance_damage))
  end
end
