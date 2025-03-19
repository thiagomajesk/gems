defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  alias GEMS.Engine.Battler.Actor

  @types [:skill, :item]

  embedded_schema do
    field :type, Ecto.Enum, values: @types

    field :item, :map
    field :skill, :map

    embeds_many :targets, Actor
  end

  @chain [
    # &Action.maybe_use_food/2,
    # &Action.maybe_use_potion/2,
    # &Action.maybe_use_spell/2,
    # &Action.maybe_use_attack/2
  ]

  # def maybe_use_food(_leader, _targets), do: nil

  # def maybe_use_potion(leader, _targets) do
  #   percentage = leader.__health__ / leader.max_health * 100
  #   usable_potion = leader.__potion__ && leader.__potion__.amount > 0

  #   if percentage < 20 && usable_potion do
  #     %Action{
  #       what: :potion,
  #       source: usable_potion,
  #       targets: [leader]
  #     }
  #   end
  # end

  # def maybe_use_spell(leader, targets) do
  #   usable_spell = Enum.find(List.wrap(leader.__spells__), &(&1.cost <= leader.__energy__))

  #   # TODO: select target based on spell
  #   targets =
  #     targets
  #     |> Enum.max_by(& &1.__aggro__)
  #     |> List.wrap()

  #   if usable_spell do
  #     %Action{
  #       what: :spell,
  #       source: usable_spell,
  #       targets: targets
  #     }
  #   end
  # end

  # def maybe_use_attack(leader, targets) do
  #   targets =
  #     targets
  #     |> Enum.reject(&Actor.self?(&1, leader))
  #     |> Enum.max_by(& &1.__aggro__)
  #     |> List.wrap()

  #   %Action{
  #     what: :attack,
  #     source: leader,
  #     targets: targets
  #   }
  # end
end
