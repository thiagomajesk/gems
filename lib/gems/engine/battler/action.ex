defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  alias __MODULE__

  alias GEMS.Engine.Battler.Event

  @types [:skill, :item]

  embedded_schema do
    field :type, Ecto.Enum, values: @types

    field :item, :map
    field :skill, :map

    embeds_many :targets, GEMS.Engine.Battler.Actor
  end

  def events_for(%Action{type: :skill} = action) do
    Enum.map(action.targets, fn target ->
      %Event{
        target: target,
        effects: action.skill.effects
      }
    end)
  end

  def events_for(%Action{type: :item} = action) do
    Enum.map(action.targets, fn target ->
      %Event{
        target: target,
        effects: action.item.effects
      }
    end)
  end
end
