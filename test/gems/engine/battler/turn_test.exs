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
      action = build_action(action_pattern)

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is random" do
      action_pattern =
        build_action_pattern(%{
          condition: :random,
          chance: 1
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern)

      assert %Turn{action: ^action} = Turn.choose_action(turn)
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
      action = build_action(action_pattern)

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is health number" do
      action_pattern =
        build_action_pattern(%{
          condition: :health_number,
          min_health: 0,
          maximum_health: 10
        })

      leader = %Actor{health: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern)

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is energy number" do
      action_pattern =
        build_action_pattern(%{
          condition: :energy_number,
          min_energy: 0,
          maximum_energy: 10
        })

      leader = %Actor{energy: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern)

      assert %Turn{action: ^action} = Turn.choose_action(turn)
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

  defp build_action(action_pattern) do
    Map.merge(action_fixture(), %{
      health_cost: action_pattern.skill.health_cost,
      energy_cost: action_pattern.skill.energy_cost,
      affinity: action_pattern.skill.affinity,
      target_side: action_pattern.skill.target_side,
      target_number: action_pattern.skill.target_number,
      random_targets: action_pattern.skill.random_targets,
      effects: action_pattern.skill.effects
    })
  end

  defp action_pattern_fixture(),
    do: %ActionPattern{
      id: Ecto.UUID.generate(),
      priority: 1,
      condition: :always,
      chance: 0,
      start_turn: 0,
      every_turn: 0,
      min_health: 0,
      maximum_health: 10,
      min_energy: 0,
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
      target_side: :self,
      target_number: 0,
      random_targets: 0,
      effects: []
    }

  defp action_fixture(),
    do: %Action{
      health_cost: 0,
      energy_cost: 0,
      affinity: 0,
      target_side: 0,
      target_number: 0,
      random_targets: 0,
      effects: []
    }
end
