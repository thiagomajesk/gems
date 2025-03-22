defmodule GEMS.Engine.BattlerTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler
  alias GEMS.Engine.Battler.Turn
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Battle
  alias GEMS.Engine.Battler.Action

  # describe "battler" do
  #   test "only runs up to max_turns" do
  #     actor_1 = actor_fixture(:alpha)
  #     actor_2 = actor_fixture(:bravo)

  #     actors = [actor_1, actor_2]

  #     battle = Battle.new(actors, max_turns: 2)
  #     assert %Battle{turns: [_one | _two]} = Battler.run(battle)
  #   end

  #   test "finds the leader" do
  #     actor_1 = %{actor_fixture(:alpha) | charge: 10}
  #     actor_2 = %{actor_fixture(:bravo) | charge: 20}

  #     actors = [actor_1, actor_2]

  #     battle = Battle.new(actors, max_turns: 2)
  #     assert ^actor_2 = Battle.find_leader(battle)
  #   end
  # end

  # describe "turn" do
  #   test "chooses the proper action" do
  #     actor_1 = actor_fixture(:alpha)
  #     actor_2 = actor_fixture(:bravo)

  #     turn = Turn.new(1, actor_1, [actor_2])

  #     action = %Action{type: :skill, skill: basic_attack_skill_fixture(), targets: [actor_2]}

  #     assert %Turn{action: ^action} = Turn.choose_action(turn)
  #   end
  # end

  # defp actor_fixture(party) do
  #   %Actor{
  #     party: party,
  #     health: 10,
  #     mana: 10,
  #     aggro: 0,
  #     charge: 0,
  #     armor_rating: 1,
  #     max_health: 1,
  #     health_regen: 1,
  #     attack_damage: 1,
  #     weapon_power: 1,
  #     evasion_rating: 1,
  #     attack_speed: 1,
  #     critical_rating: 1,
  #     accuracy_rating: 1,
  #     critical_power: 1,
  #     magic_resist: 1,
  #     max_mana: 1,
  #     mana_regen: 1,
  #     magic_damage: 1,
  #     skill_power: 1,
  #     action_patterns: [basic_attack_action_pattern_fixture()]
  #   }
  # end

  # defp basic_attack_action_pattern_fixture() do
  #   %{
  #     id: 1,
  #     type: :skill,
  #     priority: 1,
  #     condition: :always,
  #     skill: basic_attack_skill_fixture()
  #   }
  # end

  # defp basic_attack_skill_fixture() do
  #   %{
  #     id: 1,
  #     name: "Attack",
  #     code: "attack",
  #     target_side: :enemy,
  #     target_status: :alive,
  #     target_number: 1,
  #     random_targets: 0,
  #     hit_type: :physical,
  #     success_rate: 1.0,
  #     repeats: 1,
  #     damage_element: element_fixture(),
  #     damage_type: :health_damage,
  #     damage_variance: 0.0,
  #     critical_hits: false
  #   }
  # end

  # defp element_fixture() do
  #   %{id: 1, name: "Physical"}
  # end

  # defp recovery_effect_fixture() do
  #   %{
  #     kind: :recovery,
  #     recovery: %{
  #       parameter: :health,
  #       flat: 10,
  #       rate: 0.0,
  #       variance: 0.1,
  #       maximum: 20
  #     }
  #   }
  # end

  # defp state_change_effect_fixture() do
  #   %{
  #     kind: :state_change,
  #     state_change: %{
  #       action: :add,
  #       chance: 1.0,
  #       state: %{
  #         id: 1,
  #         name: "Poison",
  #         code: "poison",
  #         traits: []
  #       }
  #     }
  #   }
  # end

  # defp parameter_change_effect_fixture() do
  #   %{
  #     kind: :parameter_change,
  #     parameter_change: %{
  #       parameter: :max_health,
  #       type: :buff,
  #       action: :add,
  #       turns: 1
  #     }
  #   }
  # end
end
