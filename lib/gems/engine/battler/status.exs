defmodule GEMS.Engine.Battler.Status do
  @moduledoc """

  - Burning: Deals fixed Fire damage each turn.
  - Poisoned: Deals fixed Earth damage each turn.
  - Frozen: Deals fixed Water damage each turn.
  - Shocked: Deals fixed Air damage each turn.
  - Bleeding: Deals physical damage each turn based on a percentage of the actor's max Energy.

  - Stunned: Reduces charge to 0
  - Marked: Increases aggro to 100
  - Blighted: Regeneration is negated
  - Silenced: The actor can't use skills (only makes sense if we also have items)

  - Buff: Increases the stat by a %
  - Debuff: Decreases the stat by a %
  """
end
