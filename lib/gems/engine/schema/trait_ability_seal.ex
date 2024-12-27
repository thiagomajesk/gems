defmodule GEMS.Engine.Schema.TraitAbilitySeal do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:ability_id]

  schema "traits_abilities_seals" do
    belongs_to :ability, GEMS.Engine.Schema.Ability
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_ability_seal, attrs) do
    trait_ability_seal
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ability)
  end
end
