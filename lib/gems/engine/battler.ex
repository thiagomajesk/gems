defmodule GEMS.Engine.Battler do
  alias GEMS.Engine.Battler.Battle
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Action

  def run(%Battle{turns: turns} = battle)
      when length(turns) >= battle.max_turns,
      do: battle

  def run(%Battle{status: :finished} = battle),
    do: battle

  def run(%Battle{status: :running} = battle),
    do: run(next(battle))

  defp next(%Battle{status: :finished} = battle), do: battle

  defp next(%Battle{status: :running} = battle) do
    battle
    |> setup_phase()
    |> upkeep_phase()
    |> combat_phase()
    |> cleanup_phase()
    |> checks_phase()
  end

  defp setup_phase(battle) do
    battle
    |> Battle.charge_actors()
  end

  # TODO: Tick effects, auras and others
  defp upkeep_phase(battle) do
    battle
  end

  defp combat_phase(battle) do
    turn = process_turn(battle)

    turn.updated
    |> Enum.reduce(battle, &Battle.replace_actor(&2, &1))
    |> Map.update!(:turns, &[turn | &1])
  end

  defp process_turn(battle) do
    battle
    |> build_turn()
    |> Turn.choose_action()
    |> Turn.perform_action()
  end

  defp build_turn(battle) do
    number = length(battle.turns) + 1

    leader = Battle.find_leader(battle)
    actors = Enum.reject(battle.actors, &Actor.self?(&1, leader))

    Turn.new(number, leader, actors)
  end

  defp cleanup_phase(battle) do
    battle
    |> Battle.decrease_aggro()
  end

  defp checks_phase(battle) do
    dead = Enum.filter(battle.actors, &Actor.dead?/1)
    alive = Enum.filter(battle.actors, &Actor.alive?/1)

    one_actor_alive? = Enum.count(alive) == 1
    all_actors_dead? = Enum.count(battle.actors) == Enum.count(dead)
    one_party_alive? = length(Enum.uniq_by(alive, & &1.party)) == 1

    cond do
      all_actors_dead? -> %{battle | status: :finished}
      one_actor_alive? -> %{battle | status: :finished}
      one_party_alive? -> %{battle | status: :finished}
      true -> battle
    end
  end
end
