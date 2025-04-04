defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Event

  embedded_schema do
    field :summary, :map, default: %{}
    field :number, :integer, default: 0

    embeds_one :actors, GEMS.Engine.Battler.Actor
    embeds_one :leader, GEMS.Engine.Battler.Actor
    embeds_one :action, GEMS.Engine.Battler.Action
    embeds_many :events, GEMS.Engine.Battler.Event
    embeds_many :updated, GEMS.Engine.Battler.Actor
  end

  def new(number, leader, actors) do
    %Turn{number: number, leader: leader, actors: actors}
  end

  def choose_action(%Turn{} = turn) do
    turn.leader.action_patterns
    |> Enum.sort_by(& &1.priority)
    |> Enum.reduce_while(turn, fn action_pattern, turn ->
      action = build_action(action_pattern, turn)

      if action_can_be_performed?(action, turn) and
           action_pattern_matches?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  def create_events(%Turn{action: nil} = turn), do: turn

  def create_events(%Turn{} = turn) do
    dbg(turn.action)
    caster_events = events_for(turn.action.caster_effects, turn.leader, [turn.leader])
    target_events = events_for(turn.action.target_effects, turn.leader, turn.action.targets)

    %{turn | events: Enum.concat(caster_events, target_events)}
  end

  def process_events(%Turn{events: []} = turn), do: turn

  def process_events(%Turn{} = turn) do
    events =
      turn.events
      |> Enum.reverse()
      |> Enum.map(&Event.apply_effects/1)

    updated = Enum.map(events, & &1.target)

    turn
    |> Map.put(:events, events)
    |> Map.put(:updated, updated)
  end

  defp action_can_be_performed?(action, turn) do
    Enum.any?(action.targets) and
      turn.leader.health >= action.health_cost and
      turn.leader.energy >= action.energy_cost
  end

  defp action_pattern_matches?(%{condition: :always}, _turn),
    do: true

  defp action_pattern_matches?(%{condition: :random} = action_pattern, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches?(%{condition: :turn_number} = action_pattern, turn),
    do:
      turn.number >= action_pattern.start_turn and
        rem(turn.number - action_pattern.start_turn, action_pattern.every_turn) == 0

  defp action_pattern_matches?(%{condition: :health_number} = action_pattern, turn),
    do:
      action_pattern.minimum_health <= turn.leader.health and
        action_pattern.maximum_health >= turn.leader.health

  defp action_pattern_matches?(%{condition: :energy_number} = action_pattern, turn),
    do:
      action_pattern.minimum_energy <= turn.leader.energy and
        action_pattern.maximum_energy >= turn.leader.energy

  defp list_valid_targets(%{skill: %{target_scope: :self}}, turn),
    do: [turn.leader]

  defp list_valid_targets(%{skill: %{target_scope: :anyone}}, turn),
    do: turn.actors

  defp list_valid_targets(%{skill: %{target_scope: :ally}}, turn),
    do: Enum.filter(turn.actors, &Actor.ally?(&1, turn.leader))

  defp list_valid_targets(%{skill: %{target_scope: :enemy}}, turn),
    do: Enum.filter(turn.actors, &Actor.enemy?(&1, turn.leader))

  defp build_action(%{skill: skill} = action_pattern, turn) do
    valid_targets = list_valid_targets(action_pattern, turn)
    selected_targets = select_targets(valid_targets, skill)

    %Action{
      name: skill.name,
      affinity: skill.affinity,
      targets: selected_targets,
      health_cost: skill.health_cost,
      energy_cost: skill.energy_cost,
      caster_effects: skill.caster_effects,
      target_effects: skill.target_effects
    }
  end

  defp select_targets(actors, skill) do
    sorted = Enum.sort_by(actors, & &1.aggro, :desc)
    fixed_targets = Enum.take(sorted, skill.target_number)

    remaining = actors -- fixed_targets
    random_targets = Enum.take_random(remaining, skill.random_targets)

    Enum.concat(fixed_targets, random_targets)
  end

  defp events_for([], _source, _targets), do: []

  defp events_for(effects, source, targets) do
    Enum.map(targets, fn target ->
      effects = filter_effects(effects)
      Event.new(source, target, effects)
    end)
  end

  defp filter_effects(effects) do
    Enum.filter(effects, fn
      %{chance: chance} -> chance >= :rand.uniform()
      _event -> true
    end)
  end
end
