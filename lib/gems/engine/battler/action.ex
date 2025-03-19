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
end
