defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  @affinities GEMS.Engine.Constants.elements()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities
    field :repeats, :integer
    field :action_cost, :integer

    field :target_ids, {:array, Ecto.UUID}, virtual: true, default: []

    embeds_many :effects, GEMS.Engine.Battler.Effect
  end
end
