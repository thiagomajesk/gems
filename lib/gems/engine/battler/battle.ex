defmodule GEMS.Engine.Battler.Battle do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  @max_turns 100
  @charge_threshold 100

  # Duel: 1v1
  # Raid: PvE
  # Brawl: FFA
  # Wingman: 2v2
  # Skirmish: ZvZ

  @types [:duel, :raid, :brawl, :wingman, :skirmish]
  @statuses [:running, :finished]

  embedded_schema do
    field :type, Ecto.Enum, values: @types
    field :status, Ecto.Enum, values: @statuses
    field :max_turns, :integer, virtual: true

    embeds_many :actors, GEMS.Engine.Battler.Actor
    embeds_many :turns, GEMS.Engine.Battler.Turn
  end

  def new(actors, opts \\ []) do
    type = Keyword.get(opts, :type)
    max_turns = Keyword.get(opts, :max_turns, @max_turns)
    %Battle{status: :running, type: type, actors: actors, max_turns: max_turns}
  end

  def charge_actors(%Battle{} = battle) do
    Map.update!(battle, :actors, fn actors ->
      total_speed = Enum.sum_by(actors, & &1.attack_speed)

      Enum.map(actors, fn actor ->
        speed = relative_speed(actor, total_speed)
        # Guarantees that charges will overflow after the threshold
        # resulting in a more granular flow of initiative, for instance
        # an actor with 50% more attack speed will attack twice sometimes
        # and an actor with 100% more attack speed will attack twice often.
        Map.update!(actor, :charge, &rem(&1 + speed, @charge_threshold))
      end)
    end)
  end

  def decrease_aggro(%Battle{} = battle) do
    Map.update!(battle, :actors, fn actors ->
      Enum.map(actors, fn actor ->
        Map.update!(actor, :aggro, &max(&1 - 1, 0))
      end)
    end)
  end

  def apply_states(%Battle{} = battle), do: battle

  def remove_states(%Battle{} = battle), do: battle

  def replace_actors(%Battle{} = battle, actors) do
    Enum.reduce(actors, battle, fn actor, battle ->
      Map.update!(battle, :actors, fn actors ->
        Enum.map(actors, fn existing ->
          if Actor.self?(existing, actor),
            do: actor,
            else: existing
        end)
      end)
    end)
  end

  def find_leader(%Battle{} = battle) do
    battle.actors
    |> Enum.reject(&Actor.dead?/1)
    |> Enum.max_by(&{&1.charge, :rand.uniform()})
  end

  defp relative_speed(actor, total_speed) do
    div(actor.attack_speed * @charge_threshold, total_speed)
  end
end
