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

  def attributes,
    do: [
      :strength,
      :dexterity,
      :intelligence,
      :wisdom
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
      :aether
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

  # FIRE
  # Oiled: Increase fire damage taken by 50%
  # Warm: Increase fire damage taken by 80%
  # Burning: Deals damage over time
  #
  # WATER
  # Wet: Increase water damage taken by 50%
  # Chilled: Attack speed is reduced by 20%
  # Frozen: Attack speed is reduced to 0
  #
  # EARTH
  # Muddy: Increase earth damage taken by 50%
  # Rooted: Attack speed is reduced to 0
  # Poisoned: Deals damage over time
  #
  # AIR
  # Ventilated: Increase air damage taken by 50%
  # Dazed: Accuracy rating is reduced by 20%
  # Stunned: Increase damage taken by %30
  #
  # AETHER
  # Bleeding: Deals damage over time based on a % of max health
  # Blighted: Lowers the evasion and accuracy by 20%
  # Silenced: Prevents the use of spells
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
