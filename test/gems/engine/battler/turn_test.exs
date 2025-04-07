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
          trigger: :turn_number,
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
          trigger: :health_number,
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

    test "when trigger is energy number" do
      action_pattern =
        build(:action_pattern, %{
          trigger: :energy_number,
          minimum_energy: 0,
          maximum_energy: 10
        })

      actor =
        build(:actor, %{
          energy: 5,
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
          energy: 5,
          action_patterns: [action_pattern]
        })

      turn = Turn.new(1, [actor])

      assert %Turn{action: nil, events: []} = Turn.process_action(turn)
    end
  end
end
