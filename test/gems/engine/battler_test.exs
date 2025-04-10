defmodule GEMS.Engine.BattlerTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler
  alias GEMS.Engine.Battler.Battle

  import GEMS.Factory

  describe "battler" do
    test "only runs up to max_turns" do
      actor = build(:actor)

      battle = Battle.new([actor], max_turns: 2)
      assert %Battle{turns: [_one | _two]} = Battler.run(battle)
    end

    test "charge_actors/1" do
      [actor_1, actor_2] = build_pair(:actor, %{attack_speed: 10})

      battle = Battle.new([actor_1, actor_2], max_turns: 1)
      assert %Battle{actors: [%{charge: 50}, %{charge: 50}]} = Battler.run(battle)
    end

    test "decrease_aggro/1" do
      actor_1 = build(:actor, %{aggro: 1})
      actor_2 = build(:actor, %{aggro: 0})

      battle = Battle.new([actor_1, actor_2], max_turns: 1)
      assert %Battle{actors: [%{aggro: 0}, %{aggro: 0}]} = Battler.run(battle)
    end
  end
end
