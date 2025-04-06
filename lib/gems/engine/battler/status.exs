defmodule GEMS.Engine.Battler.Status do
  @moduledoc """
  # Status Effects
  Status effects are temporary conditions that can be applied to actors in combat.
  They can be either debuffs (negative effects) or buffs (positive effects).
  Each status effect has a specific duration and can be triggered by various actions.

  ## Debuffs

  - Burning: Deals fixed Fire damage each turn.
  - Poisoned: Deals fixed Earth damage each turn.
  - Frozen: Deals fixed Water damage each turn.
  - Shocked: Deals fixed Air damage each turn.
  - Bleeding: Deals physical damage each turn based on a percentage of the actor's max Energy.
  - Blighted: Healing on this actor is weakened or nullified.
  - Stunned: The actor skips its next turn and then recovers.
  - Petrified: The actor cannot act, move, or be harmed.
  - Silenced: The actor cannot use skills.
  - Charmed: The actor attacks allies and cannot be controlled.
  - Weakened: Physical and magical damage is lowered.
  - Slowed: The actor's attack speed is reduced, acting less frequently.
  - Averse: The actor takes extra damage from a specific element (e.g. Fire-Averse).
  - Drained: The actor's Max Health is lowered.
  - Withered: The actor's Max Energy is lowered.
  - Breached: Physical defense is lowered.
  - Exposed: Magical defense is lowered.
  - Frightened: Attack and defense are reduced by fear.
  - Marked: Enemies focus their attacks on this actor (increase aggro to 100%).
  - Deceased: The actor is dead and removed from combat.

  ## Buffs

  - Strengthened: Increases physical damage dealt.
  - Fortified: Increases physical defense.
  - Amplified: Increases magical damage dealt.
  - Resilient: Increases magical defense.
  - Hasted: The actor gains turns more frequently.
  - Shielded: Negates the next single attack or spell entirely.
  - Evasive: Improves evasion, making the actor harder to hit.
  - Touched: Adds an elemental property (e.g. Fire-Touched) to attacks.
  - Steadfast: Halves the duration of new debuffs on the actor or blocks forced movement (pick whichever fits best).
  - Mending: Amplifies healing done by the actor's spells or abilities.
  - Blessed: Lowers the chance of being inflicted with new debuffs.
  - Barrier: Reduces all incoming damage by a fixed percentage.
  - Focused: Increases critical hit rate or critical damage.
  - Tenacity: Each time the actor takes damage, it gains a stack that reduces subsequent damage, up to a limit.
  - Encouraged: Slightly boosts both physical/magical offense and defense.
  - Serenity: Recovers a small amount of Health each turn.
  - Galvanised: Makes the actor immune to all attacks for a short duration.
  - Warded: Greatly reduces elemental damage (Fire, Earth, Water, Air) taken.
  - Adrenaline: (Berserk) Grants a significant offensive advantage for a limited time, but imposes a penalty afterward (e.g. reduced defense).
  - Inspired: Temporarily reduces skill costs (Health, stamina, etc.) for the actor's abilities.
  """
end
