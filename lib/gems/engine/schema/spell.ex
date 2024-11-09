defmodule GEMS.Engine.Schema.Spell do
  defstruct [
    :name,
    :description,
    :code,
    # active, passive
    :type,
    # instant (when called or condition)
    :trigger,
    :stack,
    # selector + (self, ally or enemy)
    :target,
    :cost,
    :recast,
    :effects
  ]

  # def new(:heroic_strike) do
  #   %Spell{
  #     name: "Heroic Strike",
  #     code: :heroic_strike,
  #     type: :active,
  #     trigger: :instant,
  #     target: %{who: :enemy, selector: :any},
  #     cost: 10,
  #     recast: 1,
  #     effects: [
  #       %{type: :damage, target: :enemy, amount: 77},
  #       %{
  #         type: :cast_spell,
  #         target: :self,
  #         conditions: %{name: :mob_stack_immunity, type: :unless_spell_active, target: :self},
  #         spell: :heroic_stack
  #       }
  #     ]
  #   }
  # end

  # def new(:heroic_stack) do
  #   %Spell{
  #     name: "Heroic Stack",
  #     code: :heroic_stack,
  #     type: :passive,
  #     trigger: :instant,
  #     target: %{who: :self},
  #     stack: 3,
  #     effects: [
  #       %{
  #         type: :buff,
  #         value: 10,
  #         target: :self,
  #         stat: :attack_speed,
  #         duration: 6
  #       }
  #     ]
  #   }
  # end

  # def new(:heroic_cleave) do
  #   %Spell{
  #     name: "Heroic Cleave",
  #     code: :heroic_cleave,
  #     type: :active,
  #     trigger: :instant,
  #     target: %{who: :enemy, selector: %{count: 3, pick: :random}},
  #     cost: 10,
  #     recast: 1,
  #     effects: [
  #       %{
  #         type: :damage,
  #         target: :enemy,
  #         amount: 100
  #       }
  #     ]
  #   }
  # end
end
