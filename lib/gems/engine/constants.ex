defmodule GEMS.Engine.Constants do
  @min_stamina 86400

  @doc """
  Returns the maximum stamina available to all characters.
  The maximum stamina represents the number of seconds in a day.
  """
  def max_stamina(level) when level >= 1000, do: @min_stamina * 2.0
  def max_stamina(level) when level >= 500, do: @min_stamina * 1.0
  def max_stamina(level) when level >= 100, do: @min_stamina * 0.5
  def max_stamina(_level), do: @min_stamina

  def parties,
    do: [
      :alpha,
      :bravo,
      :charlie,
      :delta
    ]

  def statistics,
    do: [
      :damage,
      :accuracy,
      :evasion,
      :fortitude,
      :recovery,
      :maximum_health,
      :maximum_physical_armor,
      :maximum_magical_armor,
      :attack_speed,
      :critical_chance,
      :critical_multiplier,
      :damage_penetration,
      :damage_reflection,
      :health_regeneration,
      :fire_resistance,
      :water_resistance,
      :earth_resistance,
      :air_resistance
    ]

  # TODO: Remove tiers and use rarities instead
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

  def slots,
    do: [
      :trinket,
      :helmet,
      :cape,
      :main_hand,
      :armor,
      :off_hand,
      :ring,
      :boots,
      :amulet
    ]

  def elements,
    do: [
      :air,
      :earth,
      :fire,
      :water,
      :neutral
    ]

  def target_scopes,
    do: [
      :self,
      :ally,
      :enemy,
      :anyone
    ]

  def damage_types,
    do: [
      :physical,
      :magical,
      :certain
    ]

  def conditions,
    do: [
      :burning,
      :poisoned,
      :frozen,
      :shocked,
      :bleeding,
      :stunned,
      :marked,
      :blighted,
      :silenced,
      :fortified,
      :vulnerable
    ]

  def triggers,
    do: [
      :always,
      :random,
      :when_turn,
      :when_health,
      :when_action_points,
      :when_condition_absent,
      :when_condition_present
    ]

  def effect_types_mappings,
    do: [
      apply_condition: GEMS.Database.Effects.ApplyCondition,
      damage_flat: GEMS.Database.Effects.DamageFlat,
      damage_rate: GEMS.Database.Effects.DamageRate,
      resource_drain: GEMS.Database.Effects.HealthDrain,
      resource_regen: GEMS.Database.Effects.HealthRegen,
      restoration: GEMS.Database.Effects.Restoration,
      stat_change: GEMS.Database.Effects.StatChange
    ]
end
