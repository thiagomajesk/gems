defmodule GEMS.Engine.Battler.Battle do
  alias __MODULE__
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Actor

  defstruct status: nil, result: nil, actors: [], turns: []

  @charge_threshold 100

  def new(actors), do: %Battle{status: :running, actors: actors}

  def next(%Battle{status: nil} = battle), do: battle

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

      Enum.map(actors, fn actor ->
        relative_speed = relative_speed(actor, total_speed)
        Map.put(actor, :__speed__, relative_speed)
      end)
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
        Map.update!(actor, :__charge__, fn charge ->
          # Guarantees that charges will overflow after the threshold
          # resulting in a more granular flow of initiative, for instance
          # an actor with 50% more attack speed will attack twice sometimes
          # and an actor with 100% more attack speed will attack twice often.
          rem(charge + actor.__speed__, @charge_threshold)
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
        Map.update!(actor, :__aggro__, fn aggro ->
          max(aggro - 1, 0)
        end)
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

    everyone_dead? = Enum.count(battle.actors) == Enum.count(dead)
    single_actor_alive? = Enum.count(alive) == 1

    single_team_alive? = length(Enum.uniq_by(alive, & &1.__party__)) == 1

    cond do
      everyone_dead? ->
        %{battle | status: nil, result: :draw}

      single_actor_alive? ->
        %{battle | status: nil, result: :victory}

      single_team_alive? ->
        %{battle | status: nil, result: :victory}

      true ->
        battle
    end
  end
end
