defmodule GEMS.Engine.Battler.TurnTest do
  use ExUnit.Case, async: true

  import GEMS.Factory

  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Action

  test "new/2 sorts actors by charge" do
    actor_1 = build(:actor, %{charge: 1})
    actor_2 = build(:actor, %{charge: 0})

    actors = [actor_2, actor_1]

    %Turn{actors: actors} = Turn.new(1, actors)
    assert [%{charge: 1}, %{charge: 0}] = actors
  end

  describe "choose_action/1" do
    test "action is skipped when no action patterns are available" do
      actor = build(:actor)

      turn = Turn.new(1, [actor])
      assert %Turn{action: nil} = Turn.choose_action(turn)
    end

    test "when trigger is always" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :always
        })

      actor =
        build(:actor, %{
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])
      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when trigger is random" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :random,
          chance: 1
        })

      actor =
        build(:actor, %{
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when trigger is turn number" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :when_turn,
          start_turn: 1,
          every_turn: 1
        })

      actor =
        build(:actor, %{
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when trigger is health number" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :when_health,
          minimum_health: 0,
          maximum_health: 10
        })

      actor =
        build(:actor, %{
          health: 5,
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when trigger is action points number" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :when_action_points,
          minimum_action_points: 0,
          maximum_action_points: 10
        })

      actor =
        build(:actor, %{
          action_points: 5,
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end
  end

  describe "process_action/1" do
    test "action is skipped when no action was chosen" do
      action_pattern = build(:action_pattern)

      actor =
        build(:actor, %{
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: nil, events: []} = Turn.process_action(turn)
    end
  end
end
