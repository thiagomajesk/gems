defmodule GEMS.Engine.Battler do
  alias GEMS.Engine.Battler.Battle
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Event

  def run(%Battle{status: :finished} = battle),
    do: battle

  def run(%Battle{status: :running} = battle),
    do: run(next(battle))

  defp next(%Battle{} = battle) do
    battle
    |> upkeep_phase()
    |> combat_phase()
    |> cleanup_phase()
    |> checks_phase()
  end

  defp upkeep_phase(battle) do
    battle
    |> Battle.charge_actors()
    |> Battle.apply_states()
  end

  defp combat_phase(battle) do
    turn = build_turn(battle)

    battle
    |> process_turn(turn)
    |> Map.update!(:turns, &[turn | &1])
  end

  defp process_turn(battle, turn) do
    turn.events
    |> Enum.reverse()
    |> Enum.reduce(battle, fn event, battle ->
      updated = Event.apply_effect(event)
      Battle.replace_actor(battle, updated)
    end)
  end

  defp build_turn(battle) do
    number = length(battle.turns) + 1

    leader = Battle.find_leader(battle)
    actors = Enum.reject(battle.actors, &Actor.self?(&1, leader))

    number
    |> Turn.new(leader, actors)
    |> Turn.choose_action()
    |> Turn.generate_events()
  end

  defp cleanup_phase(battle) do
    battle
    |> Battle.remove_states()
    |> Battle.decrease_aggro()
  end

  defp checks_phase(battle) do
    dead = Enum.filter(battle.actors, &Actor.dead?/1)
    alive = Enum.filter(battle.actors, &Actor.alive?/1)

    one_actor_alive? = length(alive) == 1
    all_actors_dead? = length(battle.actors) == length(dead)
    one_party_alive? = length(Enum.uniq_by(alive, & &1.party)) == 1
    reached_max_turns? = length(battle.turns) >= battle.max_turns

    # TODO: Add additinal metadata for battle termination.
    cond do
      all_actors_dead? -> %{battle | status: :finished}
      one_actor_alive? -> %{battle | status: :finished}
      one_party_alive? -> %{battle | status: :finished}
      reached_max_turns? -> %{battle | status: :finished}
      true -> battle
    end
  end
end
