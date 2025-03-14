defmodule GEMS.Engine.Battler.Battle do
  alias __MODULE__
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Actor

  defstruct status: nil, result: nil, actors: [], turns: []

  @charge_threshold 10

  def new(actors), do: %Battle{status: :running, actors: actors}

  def next(%Battle{status: :finished} = battle), do: battle

  def next(%Battle{status: :running} = battle) do
    battle
    |> setup_phase()
    |> upkeep_phase()
    |> combat_phase()
    |> cleanup_phase()
    |> checks_phase()
  end

  defp setup_phase(battle) do
    Map.update!(battle, :actors, fn actors ->
      total_speed = Enum.sum(Enum.map(actors, & &1.attack_speed))
      Enum.map(actors, &Map.put(&1, :speed, relative_speed(&1, total_speed)))
    end)
  end

  # TODO: Tick effects, auras and others
  defp upkeep_phase(battle) do
    battle
    |> charge_actors()
  end

  defp charge_actors(battle) do
    Map.update!(battle, :actors, fn actors ->
      Enum.map(actors, fn actor ->
        Map.update!(actor, :charge, fn charge ->
          # Guarantees that charges will overflow after the threshold
          # resulting in a more granular flow of initiative, for instance
          # an actor with 50% more attack speed will attack twice sometimes
          # and an actor with 100% more attack speed will attack twice often.
          rem(charge + actor.speed, @charge_threshold)
        end)
      end)
    end)
  end

  defp relative_speed(actor, total_speed) do
    div(actor.attack_speed * @charge_threshold, total_speed)
  end

  defp combat_phase(battle) do
    turn = Turn.process(build_turn(battle))

    turn.updated
    |> Enum.reduce(battle, &replace_actor(&2, &1))
    |> Map.update!(:turns, &[turn | &1])
  end

  defp build_turn(battle) do
    number = length(battle.turns) + 1
    Turn.new(number, battle.actors)
  end

  defp cleanup_phase(battle) do
    battle
    |> decrease_aggro()
  end

  defp decrease_aggro(battle) do
    Map.update!(battle, :actors, fn actors ->
      Enum.map(actors, fn actor ->
        Map.update!(actor, :aggro, &max(&1 - 1, 0))
      end)
    end)
  end

  defp replace_actor(battle, actor) do
    Map.update!(battle, :actors, fn actors ->
      Enum.map(actors, fn existing ->
        if Actor.self?(existing, actor),
          do: actor,
          else: existing
      end)
    end)
  end

  defp checks_phase(battle) do
    dead = Enum.filter(battle.actors, &Actor.dead?/1)
    alive = Enum.filter(battle.actors, &Actor.alive?/1)

    one_actor_alive? = Enum.count(alive) == 1
    all_actors_dead? = Enum.count(battle.actors) == Enum.count(dead)
    one_party_alive? = length(Enum.uniq_by(alive, & &1.party)) == 1

    cond do
      all_actors_dead? ->
        %{battle | status: nil, result: :draw}

      one_actor_alive? ->
        [%{party: party}] = alive
        %{battle | status: nil, result: {:victory, party}}

      one_party_alive? ->
        [%{party: party} | _] = alive
        %{battle | status: nil, result: {:victory, party}}

      true ->
        battle
    end
  end
end
