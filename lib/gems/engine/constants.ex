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

  def target_sides,
    do: [
      :self,
      :ally,
      :enemy,
      :anyone
    ]

  def target_scopes,
    do: [
      :target,
      :performer,
      :target_group,
      :performer_group
    ]

  def damage_types,
    do: [
      :physical,
      :magical,
      :certain
    ]

  def charges,
    do: [
      :heated,
      :soaked,
      :muddy,
      :breezy
    ]

  def states,
    do: [
      :burning,
      :frozen,
      :poisoned,
      :stunned,
      :silenced,
      :bleeding,
      :blighted
    ]

  def buffs, do: []

  def debuffs,
    do: []

  def effect_types_mappings,
    do: [
      health_damage: GEMS.Database.Effects.HealthDamage,
      apply_status: GEMS.Database.Effects.ApplyStatus
    ]
end
