defmodule GEMS.Engine.Schema.TraitAttackElement do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:element_id]

  schema "traits_attack_elements" do
    belongs_to :element, GEMS.Engine.Schema.Element
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_attack_element, attrs) do
    trait_attack_element
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:element)
  end
end
