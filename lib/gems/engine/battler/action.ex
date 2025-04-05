defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  @affinities GEMS.Engine.Constants.elements()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities
    field :health_cost, :integer
    field :energy_cost, :integer

    field :critical?, :boolean, default: false
    field :target_ids, {:array, Ecto.UUID}, default: []

    embeds_many :effects, GEMS.Engine.Battler.Effect
  end
end
