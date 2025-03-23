defmodule GEMS.Engine.ActorTest do
  use ExUnit.Case, async: true

  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.State
  alias GEMS.Engine.Schema.Trait
  alias GEMS.Engine.Schema.TraitAttackElement
  alias GEMS.Engine.Schema.TraitAttackSkill
  alias GEMS.Engine.Schema.TraitAttackState
  alias GEMS.Engine.Schema.TraitElementRate
  alias GEMS.Engine.Schema.TraitItemSeal
  alias GEMS.Engine.Schema.TraitParameterChange
  alias GEMS.Engine.Schema.TraitParameterRate
  alias GEMS.Engine.Schema.TraitSkillSeal
  alias GEMS.Engine.Schema.TraitStateRate
  alias GEMS.Engine.Schema.Item

  describe "put_trait/2" do
    test "skill_seal" do
      skill = %Skill{id: 1}
      actor = %Actor{skills_sealed: []}
      trait = %Trait{kind: :skill_seal, skill_seal: %TraitSkillSeal{skill: skill}}
      assert %Actor{skills_sealed: [^skill]} = Actor.put_trait(actor, trait)
    end

    test "attack_skill" do
      skill = %Skill{id: 1}
      actor = %Actor{attack_skill: nil}
      trait = %Trait{kind: :attack_skill, attack_skill: %TraitAttackSkill{skill: skill}}
      assert %Actor{attack_skill: ^skill} = Actor.put_trait(actor, trait)
    end

    test "attack_element" do
      element = %Element{id: 1}
      actor = %Actor{attack_element: nil}
      trait = %Trait{kind: :attack_element, attack_element: %TraitAttackElement{element: element}}
      assert %Actor{attack_element: ^element} = Actor.put_trait(actor, trait)
    end

    test "attack_state" do
      state = %State{id: 1}
      actor = %Actor{attack_states: []}

      trait = %Trait{
        kind: :attack_state,
        attack_state: %TraitAttackState{state: state}
      }

      assert %Actor{attack_states: [{^state, 1.0}]} = Actor.put_trait(actor, trait)
    end

    test "parameter_rate" do
      actor = %Actor{parameter_rates: []}

      trait = %Trait{
        kind: :parameter_rate,
        parameter_rate: %TraitParameterRate{type: :buff, parameter: :health, rate: 1.0}
      }

      assert %Actor{parameter_rates: [{:buff, :health, 1.0}]} =
               Actor.put_trait(actor, trait)
    end

    test "element_rate" do
      element = %Element{id: 1}
      actor = %Actor{element_rates: []}

      trait = %Trait{
        kind: :element_rate,
        element_rate: %TraitElementRate{element: element, rate: 1.0}
      }

      assert %Actor{element_rates: [{^element, 1.0}]} =
               Actor.put_trait(actor, trait)
    end

    test "item_seal" do
      item = %Item{id: 1}
      actor = %Actor{items_sealed: []}

      trait = %Trait{
        kind: :item_seal,
        item_seal: %TraitItemSeal{item: item}
      }

      assert %Actor{items_sealed: [^item]} =
               Actor.put_trait(actor, trait)
    end

    test "parameter_change" do
      actor = %Actor{parameter_changes: []}

      trait = %Trait{
        kind: :parameter_change,
        parameter_change: %TraitParameterChange{parameter: :health, flat: 1, rate: 1.0}
      }

      assert %Actor{parameter_changes: [{:health, 1, 1.0}]} =
               Actor.put_trait(actor, trait)
    end

    test "state_rate" do
      state = %State{id: 1}
      actor = %Actor{state_rates: []}

      trait = %Trait{
        kind: :state_rate,
        state_rate: %TraitStateRate{state: state, rate: 1.0}
      }

      assert %Actor{state_rates: [{^state, 1.0}]} =
               Actor.put_trait(actor, trait)
    end
  end
end
