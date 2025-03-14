defmodule GEMS.Engine.BattlerTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Battle

  test "battle" do
    actors = actors_fixture()
    battle = Battle.new(actors)
    assert %Battle{status: :finished} = Battler.run(battle)
  end

  defp actors_fixture() do
    [
      %Actor{
        id: Ecto.UUID.generate(),
        party: :alpha,
        health: 10,
        mana: 10,
        armor_rating: 10,
        max_health: 10,
        health_regen: 10,
        attack_damage: 10,
        weapon_power: 10,
        evasion_rating: 10,
        attack_speed: 10,
        critical_rating: 10,
        accuracy_rating: 10,
        critical_power: 10,
        magic_resist: 10,
        max_mana: 10,
        mana_regen: 10,
        magic_damage: 10,
        skill_power: 10
      },
      %Actor{
        id: Ecto.UUID.generate(),
        party: :bravo,
        health: 10,
        mana: 10,
        armor_rating: 10,
        max_health: 10,
        health_regen: 10,
        attack_damage: 10,
        weapon_power: 10,
        evasion_rating: 10,
        attack_speed: 10,
        critical_rating: 10,
        accuracy_rating: 10,
        critical_power: 10,
        magic_resist: 10,
        max_mana: 10,
        mana_regen: 10,
        magic_damage: 10,
        skill_power: 10
      }
    ]
  end
end
