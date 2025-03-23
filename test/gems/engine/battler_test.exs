defmodule GEMS.Engine.BattlerTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler
  alias GEMS.Engine.Battler.Battle

  alias GEMS.Battler.ActorsFixtures

  describe "battler" do
    test "only runs up to max_turns" do
      actor = ActorsFixtures.build(:dummy)

      battle = Battle.new([actor], max_turns: 2)
      assert %Battle{turns: [_one | _two]} = Battler.run(battle)
    end

    test "charge_actors/1" do
      actor_1 = ActorsFixtures.build(:dummy, %{attack_speed: 1})
      actor_2 = ActorsFixtures.build(:dummy, %{attack_speed: 1})

      battle = Battle.new([actor_1, actor_2], max_turns: 1)
      assert %Battle{actors: [%{charge: 50}, %{charge: 50}]} = Battler.run(battle)
    end

    test "decrease_aggro/1" do
      actor_1 = ActorsFixtures.build(:dummy, %{aggro: 1})
      actor_2 = ActorsFixtures.build(:dummy, %{aggro: 0})

      battle = Battle.new([actor_1, actor_2], max_turns: 1)
      assert %Battle{actors: [%{aggro: 0}, %{aggro: 0}]} = Battler.run(battle)
    end

    test "replace_actor/2" do
      actor = ActorsFixtures.build(:dummy, %{health: 1})

      updated = %{actor | health: 2}

      battle = Battle.new([actor], max_turns: 1)
      assert %Battle{actors: [^updated]} = Battle.replace_actor(battle, updated)
    end

    test "find_leader/1" do
      actor_1 = ActorsFixtures.build(:dummy, %{charge: 1})
      actor_2 = ActorsFixtures.build(:dummy, %{charge: 2})

      battle = Battle.new([actor_1, actor_2], max_turns: 2)
      assert ^actor_2 = Battle.find_leader(battle)
    end
  end
end
