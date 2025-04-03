defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action

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

      if action_can_be_performed?(action) and
           action_pattern_matches?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  def generate_events(%Turn{action: nil} = turn), do: turn

  def generate_events(%Turn{action: action} = turn) do
    events = Action.events_for(action)

    Enum.reduce(events, turn, fn event, turn ->
      Map.update!(turn, :events, &[event | &1])
    end)
  end

  defp action_can_be_performed?(action) do
    Enum.any?(action.targets) and
      action.caster.health >= action.health_cost and
      action.caster.energy >= action.energy_cost
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
      caster: turn.leader,
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
end
