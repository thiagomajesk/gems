defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Event
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Effect
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Math

  embedded_schema do
    field :number, :integer
    field :summary, :map
    field :events, {:array, :map}

    embeds_one :leader, GEMS.Engine.Battler.Actor
    embeds_one :actors, GEMS.Engine.Battler.Actor
    embeds_one :action, GEMS.Engine.Battler.Action
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
  def perform_action(%Turn{} = turn), do: turn

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
        action_pattern.max_health >= turn.leader.health

  defp action_pattern_matches_condition?(%{condition: :mana_number} = action_pattern, turn),
    do:
      action_pattern.min_mana <= turn.leader.mana and action_pattern.max_mana >= turn.leader.mana

  defp action_pattern_matches_condition?(%{condition: :random} = action_pattern, turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches_condition?(%{condition: :always}, turn),
    do: true

  defp list_valid_targets(%{type: :skill} = action_pattern, turn) do
    case action_pattern.skill do
      %{target_side: :self} -> [turn.leader]
      %{target_side: :ally, target_status: :alive} -> list_live_allies(turn)
      %{target_side: :ally, target_status: :dead} -> list_dead_allies(turn)
      %{target_side: :enemy, target_status: :alive} -> list_live_enemies(turn)
      %{target_side: :enemy, target_status: :dead} -> list_dead_enemies(turn)
      %{target_side: :anyone, target_status: :alive} -> list_live_targets(turn)
      %{target_side: :anyone, target_status: :dead} -> list_dead_targets(turn)
    end
  end

  defp list_valid_targets(%{type: :item} = action_pattern, turn) do
    case action_pattern.item do
      %{target_side: :self} -> [turn.leader]
      %{target_side: :ally, target_status: :alive} -> list_live_allies(turn)
      %{target_side: :ally, target_status: :dead} -> list_dead_allies(turn)
      %{target_side: :enemy, target_status: :alive} -> list_live_enemies(turn)
      %{target_side: :enemy, target_status: :dead} -> list_dead_enemies(turn)
      %{target_side: :anyone, target_status: :alive} -> list_live_targets(turn)
      %{target_side: :anyone, target_status: :dead} -> list_dead_targets(turn)
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
