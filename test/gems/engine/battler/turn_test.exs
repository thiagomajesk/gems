defmodule GEMS.Engine.Battler.TurnTest do
  use ExUnit.Case, async: true, parameterize: [%{type: :item}, %{type: :skill}]

  alias GEMS.Database.Effects.HealthDamage
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.ActionPattern

  describe "choose_action/1" do
    test "no action when no valid action patterns" do
      leader = %Actor{action_patterns: []}

      turn = Turn.new(1, leader, [%Actor{}])

      assert %Turn{action: nil} = Turn.choose_action(turn)
    end

    test "when condition is always", %{type: type} do
      action_pattern =
        build_action_pattern(type, %{
          type: type,
          priority: 1,
          condition: :always
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern, [leader])

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is random", %{type: type} do
      action_pattern =
        build_action_pattern(type, %{
          priority: 1,
          condition: :random,
          chance: 1
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern, [leader])

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is turn number", %{type: type} do
      action_pattern =
        build_action_pattern(type, %{
          priority: 1,
          condition: :turn_number,
          start_turn: 1,
          every_turn: 1
        })

      leader = %Actor{action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern, [leader])

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is health number", %{type: type} do
      action_pattern =
        build_action_pattern(type, %{
          priority: 1,
          condition: :health_number,
          min_health: 0,
          maximum_health: 10
        })

      leader = %Actor{health: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern, [leader])

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end

    test "when condition is energy number", %{type: type} do
      action_pattern =
        build_action_pattern(type, %{
          priority: 1,
          condition: :energy_number,
          min_energy: 0,
          maximum_energy: 10
        })

      leader = %Actor{energy: 5, action_patterns: [action_pattern]}

      turn = Turn.new(1, leader, [%Actor{}])
      action = build_action(action_pattern, [leader])

      assert %Turn{action: ^action} = Turn.choose_action(turn)
    end
  end

  defp build_action_pattern(:item, attrs),
    do: Map.merge(%ActionPattern{type: :item, item: build_dummy_item()}, attrs)

  defp build_action_pattern(:skill, attrs),
    do: Map.merge(%ActionPattern{type: :skill, skill: build_dummy_skill()}, attrs)

  defp build_action(%{type: :item} = action_pattern, targets),
    do: %Action{type: :item, item: action_pattern.item, targets: targets}

  defp build_action(%{type: :skill} = action_pattern, targets),
    do: %Action{type: :skill, skill: action_pattern.skill, targets: targets}

  defp build_dummy_item,
    do: %Item{id: 1, name: "Potion", target_side: :self, effects: []}

  defp build_dummy_skill,
    do: %Skill{id: 1, name: "Heal", target_side: :self, effects: []}
end
