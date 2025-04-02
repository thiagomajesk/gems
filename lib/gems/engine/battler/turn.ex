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
      action = build_action(action_pattern)

      if Enum.any?(filter_possible_targets(action, turn)) and
           action_pattern_matches_condition?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  def perform_action(%Turn{action: nil} = turn), do: turn

  def perform_action(%Turn{action: action} = turn) do
    # possible_targets = filter_possible_targets(action, turn)
    # selected_targets = Action.pick_targets(action, possible_targets)

    # Enum.reduce(action.effects, turn, fn effect, turn ->
    #   Action.apply_effect(effect, )
    # end)
    turn
  end

  defp build_action(action_pattern) do
    %Action{
      id: action_pattern.skill.id,
      name: action_pattern.skill.name,
      health_cost: action_pattern.skill.health_cost,
      energy_cost: action_pattern.skill.energy_cost,
      affinity: action_pattern.skill.affinity,
      target_scope: action_pattern.skill.target_scope,
      target_number: action_pattern.skill.target_number,
      random_targets: action_pattern.skill.random_targets,
      effects: action_pattern.skill.effects
    }
  end

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

  defp filter_possible_targets(%{target_scope: :self}, turn),
    do: [turn.leader]

  defp filter_possible_targets(%{target_scope: :anyone}, turn),
    do: turn.actors

  defp filter_possible_targets(%{target_scope: :ally}, turn),
    do: Enum.filter(turn.actors, &Actor.ally?(turn.leader, &1))

  defp filter_possible_targets(%{target_scope: :enemy}, turn),
    do: Enum.filter(turn.actors, &Actor.enemy?(turn.leader, &1))
end
