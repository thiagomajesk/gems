defmodule GEMS.Engine.Constants do
  def stats,
    do: [
      :armor_rating,
      :max_health,
      :health_regen,
      :attack_damage,
      :weapon_power,
      :evasion_rating,
      :attack_speed,
      :critical_rating,
      :accuracy_rating,
      :critical_power,
      :magic_resist,
      :max_energy,
      :energy_regen,
      :magic_damage,
      :ability_power
    ]

  def tiers,
    do: [
      :t1,
      :t2,
      :t3,
      :t4,
      :t5,
      :t6,
      :t7,
      :t8,
      :t9
    ]
end
