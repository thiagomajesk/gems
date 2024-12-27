defmodule GEMS.Engine.Schema.TraitStateRate do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:state_id]

  @optional_fields [:rate]

  schema "traits_state_rates" do
    field :rate, :float

    belongs_to :state, GEMS.Engine.Schema.State
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_state_rate, attrs) do
    trait_state_rate
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:state)
  end
end
