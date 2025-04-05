defmodule GEMS.Engine.Battler.TurnTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.ActionPattern

  describe "choose_action/1" do
    test "no action when no valid action patterns" do
      leader = %Actor{action_patterns: []}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: nil} = Turn.choose_action(turn)
    end

    test "when condition is always" do
      action_pattern = build_action_pattern()

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when condition is random" do
      action_pattern =
        build_action_pattern(%{
          condition: :random,
          chance: 1
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when condition is turn number" do
      action_pattern =
        build_action_pattern(%{
          condition: :turn_number,
          start_turn: 1,
          every_turn: 1
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when condition is health number" do
      action_pattern =
        build_action_pattern(%{
          condition: :health_number,
          minimum_health: 0,
          maximum_health: 10
        })

      leader = %Actor{health: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end

    test "when condition is energy number" do
      action_pattern =
        build_action_pattern(%{
          condition: :energy_number,
          minimum_energy: 0,
          maximum_energy: 10
        })

      leader = %Actor{energy: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: %Action{}} = Turn.choose_action(turn)
    end
  end

  describe "perform_action/1" do
    test "no action is performed when no action is chosen" do
      leader = %Actor{action_patterns: []}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: nil, updated: []} = Turn.perform_action(turn)
    end
  end

  defp build_action_pattern(attrs \\ %{}),
    do: Map.merge(action_pattern_fixture(), attrs)

  defp build_skill(attrs \\ %{}), do: Map.merge(skill_fixture(), attrs)

  defp action_pattern_fixture(),
    do: %ActionPattern{
      id: Ecto.UUID.generate(),
      priority: 1,
      condition: :always,
      chance: 0,
      start_turn: 0,
      every_turn: 0,
      minimum_health: 0,
      maximum_health: 10,
      minimum_energy: 0,
      maximum_energy: 10,
      state: nil,
      skill: build_skill()
    }

  defp skill_fixture(),
    do: %Skill{
      id: Ecto.UUID.generate(),
      name: "Dummy Skill",
      description: nil,
      health_cost: 0,
      energy_cost: 0,
      affinity: :neutral,
      target_scope: :self,
      target_number: 1,
      random_targets: 0,
      source_effects: [],
      target_effects: []
    }
end
