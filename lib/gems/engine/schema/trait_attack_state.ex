defmodule GEMS.Engine.Schema.TraitAttackState do
  use GEMS.Database.Schema, :default

  @required_fields [:state_id]

  schema "traits_attack_states" do
    belongs_to :state, GEMS.Engine.Schema.State
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_attack_state, attrs) do
    trait_attack_state
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:state)
  end
end
