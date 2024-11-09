defmodule GEMS.Engine.Battler.Turn do
  alias __MODULE__
  alias GEMS.Engine.Battler.Event
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Effect
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Math

  defstruct [
    :number,
    :action,
    :leader,
    updated: [],
    events: [],
    summary: %{}
  ]

  def new(number, actors) do
    leader = find_leader(actors)
    targets = Enum.reject(actors, &Actor.self?(&1, leader))
    action = Action.pick(leader, targets)

    %Turn{
      number: number,
      leader: leader,
      action: action
    }
  end

  def process(%Turn{} = turn) do
    turn
    |> perform_action()
    |> process_events()
  end

  defp find_leader(actors) do
    actors
    |> Enum.reject(&Actor.dead?/1)
    |> Enum.max_by(&{&1.__charge__, &1.__speed__, :rand.uniform()})
  end

  defp perform_action(turn) do
    Enum.reduce(turn.action.targets, turn, fn target, turn ->
      effects = effects_for(turn.action, target)
      event = Event.new(turn.action.source, target, effects)
      Map.update!(turn, :events, fn events -> [event | events] end)
    end)
  end

  defp process_events(turn) do
    turn.events
    |> Enum.reverse()
    |> Enum.reduce(turn, fn event, turn ->
      Map.update!(turn, :updated, fn changes ->
        [Event.commit_effects(event) | changes]
      end)
    end)
  end

  defp effects_for(%Action{what: what} = action, _target)
       when what in [:spell, :potion],
       do: action.source.effects

  defp effects_for(%Action{what: :attack} = action, target) do
    damage = Math.physical_damage(action.source, target)
    crit_damage = Math.critical_damage(action.source, damage)

    hit_chance = Math.hit_chance(action.source, target)
    hit_connected = :rand.uniform() <= hit_chance

    crit_chance = Math.critical_chance(action.source, target)
    crit_connected = :rand.uniform() <= crit_chance

    [
      %Effect{
        type: :damage,
        metadata: %{
          hit: hit_connected,
          crit: crit_connected,
          amount: 100 + crit_damage
        }
      }
    ]
  end
end
