defmodule GEMS.Engine.Constants do
  @doc """
  Returns the maximum stamina available to all characters.
  The maximum stamina represents the number of seconds in a day.
  """
  def max_stamina(level \\ nil)
  def max_stamina(level) when level >= 1000, do: max_stamina() * 2.0
  def max_stamina(level) when level >= 500, do: max_stamina() * 1.0
  def max_stamina(level) when level >= 100, do: max_stamina() * 0.5
  def max_stamina(_level), do: 86400

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
      :max_mana,
      :mana_regen,
      :magic_damage,
      :skill_power
    ]

  def tiers,
    do: [
      :t0,
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
