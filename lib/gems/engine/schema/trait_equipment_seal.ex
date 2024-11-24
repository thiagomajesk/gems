defmodule GEMS.Engine.Schema.TraitEquipmentSeal do
  use GEMS.Database.Schema, :default

  @required_fields [:equipment_id]

  schema "traits_equipment_seals" do
    belongs_to :equipment, GEMS.Engine.Schema.Equipment
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_equipment_seal, attrs) do
    trait_equipment_seal
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:equipment)
  end
end
