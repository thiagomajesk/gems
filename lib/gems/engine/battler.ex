defmodule GEMS.Engine.Battler do
  alias GEMS.Engine.Battler.Battle

  @turn_threshold 10

  def run(%Battle{turns: turns} = battle)
      when length(turns) >= @turn_threshold,
      do: battle

  def run(%Battle{status: :running} = battle),
    do: run(Battle.next(battle))

  def run(%Battle{status: :finished} = battle),
    do: battle
end
