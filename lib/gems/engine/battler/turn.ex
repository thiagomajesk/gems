defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Actor

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

      if Enum.any?(action.targets) and
           action_pattern_matches?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  def perform_action(%Turn{action: nil} = turn), do: turn
  def perform_action(%Turn{} = turn), do: turn

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

  defp action_pattern_matches?(%{condition: :random} = action_pattern, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches?(%{condition: :always}, _turn),
    do: true

  defp list_valid_targets(%{skill: %{target_scope: :self}}, turn),
    do: [turn.leader]

  defp list_valid_targets(%{skill: %{target_scope: :anyone}}, turn),
    do: turn.actors

  defp list_valid_targets(%{skill: %{target_scope: :ally}}, turn),
    do: Enum.filter(turn.actors, &Actor.ally?(&1, turn.leader))

  defp list_valid_targets(%{skill: %{target_scope: :enemy}}, turn),
    do: Enum.filter(turn.actors, &Actor.enemy?(&1, turn.leader))

  defp build_action(action_pattern, turn) do
    valid_targets = list_valid_targets(action_pattern, turn)
    selected_targets = pick_targets(valid_targets, action_pattern.skill)

    %Action{
      caster: turn.leader,
      skill: action_pattern.skill,
      targets: selected_targets
    }
  end

  defp pick_targets(actors, skill) do
    sorted_actors = Enum.sort_by(actors, & &1.aggro, :desc)
    targets = Enum.take(sorted_actors, skill.target_number)

    remaining_actors = actors -- targets
    random_targets = Enum.take_random(remaining_actors, skill.random_targets)

    Enum.concat(targets, random_targets)
  end
end
