defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  @affinities GEMS.Engine.Constants.elements()
  @effect_types_mappings GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities
    field :health_cost, :integer
    field :energy_cost, :integer

    field :caster_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    field :target_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    embeds_many :targets, GEMS.Engine.Battler.Actor
  end
end
