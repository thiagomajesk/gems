defmodule GEMS.Engine.Battler.StatusEffect do
  @moduledoc """

  - Burning: Deals fixed Fire damage each turn.
  - Poisoned: Deals fixed Earth damage each turn.
  - Frozen: Deals fixed Water damage each turn.
  - Shocked: Deals fixed Air damage each turn.
  - Bleeding: Deals physical damage each turn based on a percentage of the actor's max Energy.

  - Stunned: Reduces charge to 0
  - Marked: Increases aggro to 100
  - Blighted: Regeneration is negated
  - Silenced: The actor can't use skills (only makes sense if we also have items)

  - Buff: Increases the stat by a %
  - Debuff: Decreases the stat by a %
  """
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Database.Effects.ApplyCondition
  alias GEMS.Database.Effects.StatChange

  @conditions GEMS.Engine.Constants.conditions()
  @types @conditions ++ [:buff, :debuff]

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: @types
    field :name, :string
    field :description, :string
    field :duration, :integer
  end

  def new(%ApplyCondition{} = effect) do
    name = Recase.to_title(to_string(effect.condition))

    %StatusEffect{
      name: name,
      type: effect.condition,
      duration: effect.duration,
      description: "Applies #{name} for #{effect.duration} turns"
    }
  end

  def new(%StatChange{} = effect) do
    name = Recase.to_title("#{effect.stat} #{effect.assessment}")

    %StatusEffect{
      name: name,
      type: effect.assessment,
      duration: effect.duration,
      description: "Applies #{name} for #{effect.duration} turns"
    }
  end
end
