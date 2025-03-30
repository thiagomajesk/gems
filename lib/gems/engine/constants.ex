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

  def hit_types,
    do: [
      :physical,
      :magical,
      :certain
    ]

  def roles,
    do: [
      :tank,
      :damage,
      :healer,
      :controller
    ]

  # Elemental charges (applied by skills):
  # Fire -> Warm (Aquecido)
  # Water -> Wet (Molhado)
  # Earth -> Muddy (Enlameado)
  # Air -> Breezy (Arejado)

  # States
  # Burning (applied using Warm charges)
  # Frozen (applied using Wet charges)
  # Poisoned (applied using Muddy charges)
  # Stunned (applied using Breezy charges)
  # Silenced (neutral)
  # Bleeding (neutral)
  # Blighted (neutral)

  # Elemental triggers
  # Flame (chance to apply additional fire damage)
  # Rain (chance to apply additional water damage)
  # Rock (chance to apply additional earth damage)
  # Lightning (chance to apply additional air damage)

  # Fire (STR) -> TANK
  # Water (INT) -> MAGE
  # Air (DEX) -> DPS
  # Earth (WIS) -> CONTROLER/SUPPORT

  def states,
    do: [
      :oiled,
      :warm,
      :burning,
      :wet,
      :chilled,
      :frozen,
      :muddy,
      :rooted,
      :poisoned,
      :ventilated,
      :silenced,
      :stunned
    ]
end
