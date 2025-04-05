defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  @affinities GEMS.Engine.Constants.elements()
  @target_scopes GEMS.Engine.Constants.target_scopes()
  @effect_types_mappings GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities
    field :health_cost, :integer
    field :energy_cost, :integer
    field :target_scope, Ecto.Enum, values: @target_scopes
    field :target_number, :integer
    field :random_targets, :integer

    field :source_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    field :target_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    embeds_one :source, GEMS.Engine.Battler.Actor
    embeds_many :targets, GEMS.Engine.Battler.Actor
  end
end
