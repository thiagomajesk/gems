defmodule GEMS.Engine.Schema.TraitAttackAbility do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:ability_id]

  schema "traits_attack_abilities" do
    belongs_to :ability, GEMS.Engine.Schema.Ability
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_attack_ability, attrs) do
    trait_attack_ability
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ability)
  end
end
