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
        do: {:halt, update_action(turn, action_pattern)},
        else: {:cont, turn}
    end)
  end

  def perform_action(%Turn{action: nil} = turn), do: turn

  def perform_action(%Turn{action: action} = turn) do
    events = Action.events_for(action)
    Map.put(turn, :events, events)

    # TODO: Apply events effects to actors
    # Enum.reduce(events, turn, fn effect, turn ->

    # end)
  end

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

  defp list_valid_targets(%{type: :skill} = action_pattern, turn) do
    case action_pattern.skill do
      %{target_side: :self} -> [turn.leader]
      %{target_side: :ally, target_filter: :alive} -> list_live_allies(turn)
      %{target_side: :ally, target_filter: :dead} -> list_dead_allies(turn)
      %{target_side: :enemy, target_filter: :alive} -> list_live_enemies(turn)
      %{target_side: :enemy, target_filter: :dead} -> list_dead_enemies(turn)
      %{target_side: :anyone, target_filter: :alive} -> list_live_targets(turn)
      %{target_side: :anyone, target_filter: :dead} -> list_dead_targets(turn)
    end
  end

  defp list_valid_targets(%{type: :item} = action_pattern, turn) do
    case action_pattern.item do
      %{target_side: :self} -> [turn.leader]
      %{target_side: :ally, target_filter: :alive} -> list_live_allies(turn)
      %{target_side: :ally, target_filter: :dead} -> list_dead_allies(turn)
      %{target_side: :enemy, target_filter: :alive} -> list_live_enemies(turn)
      %{target_side: :enemy, target_filter: :dead} -> list_dead_enemies(turn)
      %{target_side: :anyone, target_filter: :alive} -> list_live_targets(turn)
      %{target_side: :anyone, target_filter: :dead} -> list_dead_targets(turn)
    end
  end

  defp list_live_allies(turn) do
    turn.actors
    |> list_live_targets()
    |> Enum.filter(&Actor.ally?(&1, turn.leader))
  end

  defp list_live_enemies(turn) do
    turn.actors
    |> list_live_targets()
    |> Enum.filter(&Actor.enemy?(&1, turn.leader))
  end

  defp list_dead_allies(turn) do
    turn.actors
    |> list_dead_targets()
    |> Enum.filter(&Actor.ally?(&1, turn.leader))
  end

  defp list_dead_enemies(turn) do
    turn.actors
    |> list_dead_targets()
    |> Enum.filter(&Actor.enemy?(&1, turn.leader))
  end

  defp list_live_targets(turn) do
    Enum.filter(turn.actors, &Actor.alive?/1)
  end

  defp list_dead_targets(turn) do
    Enum.filter(turn.actors, &Actor.dead?/1)
  end

  defp update_action(turn, %{type: :skill} = action_pattern) do
    valid_targets = list_valid_targets(action_pattern, turn)
    %{skill: %{target_number: target_number, random_targets: random_targets}} = action_pattern

    Map.put(turn, :action, %Action{
      type: :skill,
      skill: action_pattern.skill,
      targets: pick_targets(valid_targets, {target_number, random_targets})
    })
  end

  defp update_action(turn, %{type: :item} = action_pattern) do
    valid_targets = list_valid_targets(action_pattern, turn)
    %{item: %{target_number: target_number, random_targets: random_targets}} = action_pattern

    Map.put(turn, :action, %Action{
      type: :item,
      item: action_pattern.item,
      targets: pick_targets(valid_targets, {target_number, random_targets})
    })
  end

  defp pick_targets(actors, {target_number, random_targets}) do
    sorted_actors = Enum.sort_by(actors, & &1.aggro, :desc)
    targets = Enum.take(sorted_actors, target_number)

    remaining_actors = actors -- targets
    random_targets = Enum.take_random(remaining_actors, random_targets)

    Enum.concat(targets, random_targets)
  end
end
