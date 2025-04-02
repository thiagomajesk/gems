defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Actor

  embedded_schema do
    field :summary, :map, default: %{}
    field :number, :integer, default: 0

    embeds_one :leader, GEMS.Engine.Battler.Actor
    embeds_one :actors, GEMS.Engine.Battler.Actor
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
      if action_pattern_matches?(action_pattern, turn),
        do: {:halt, put_action(turn, action_pattern)},
        else: {:cont, turn}
    end)
  end

  def perform_action(%Turn{action: nil} = turn), do: turn

  def perform_action(%Turn{action: _action} = turn), do: turn

  defp action_pattern_matches?(action_pattern, turn),
    do:
      action_pattern_matches_targets?(action_pattern, turn) and
        action_pattern_matches_condition?(action_pattern, turn)

  defp action_pattern_matches_targets?(action_pattern, turn),
    do: Enum.any?(list_valid_targets(action_pattern, turn))

  defp action_pattern_matches_condition?(%{condition: :turn_number} = action_pattern, turn),
    do:
      turn.number >= action_pattern.start_turn and
        rem(turn.number - action_pattern.start_turn, action_pattern.every_turn) == 0

  defp action_pattern_matches_condition?(%{condition: :health_number} = action_pattern, turn),
    do:
      action_pattern.min_health <= turn.leader.health and
        action_pattern.maximum_health >= turn.leader.health

  defp action_pattern_matches_condition?(%{condition: :energy_number} = action_pattern, turn),
    do:
      action_pattern.min_energy <= turn.leader.energy and
        action_pattern.maximum_energy >= turn.leader.energy

  defp action_pattern_matches_condition?(%{condition: :random} = action_pattern, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches_condition?(%{condition: :always}, _turn),
    do: true

  defp list_valid_targets(action_pattern, turn) do
    case action_pattern.skill do
      %{target_side: :self} -> [turn.leader]
      %{target_side: :anyone} -> turn.actors
      %{target_side: :ally} -> Enum.filter(turn.actors, &Actor.ally?(turn.leader, &1))
      %{target_side: :enemy} -> Enum.filter(turn.actors, &Actor.enemy?(turn.leader, &1))
    end
  end

  defp put_action(turn, action_pattern) do
    Map.put(turn, :action, %Action{
      health_cost: action_pattern.skill.health_cost,
      energy_cost: action_pattern.skill.energy_cost,
      affinity: action_pattern.skill.affinity,
      target_side: action_pattern.skill.target_side,
      target_number: action_pattern.skill.target_number,
      random_targets: action_pattern.skill.random_targets,
      effects: action_pattern.skill.effects
    })
  end

  # defp pick_targets(actors, {target_number, random_targets}) do
  #   sorted_actors = Enum.sort_by(actors, & &1.aggro, :desc)
  #   targets = Enum.take(sorted_actors, target_number)

  #   remaining_actors = actors -- targets
  #   random_targets = Enum.take_random(remaining_actors, random_targets)

  #   Enum.concat(targets, random_targets)
  # end
end
