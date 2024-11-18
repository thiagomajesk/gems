defmodule GEMS.Engine.Schema.EquipmentTrait do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipments_traits" do
    belongs_to :equipment, GEMS.Engine.Schema.Equipment
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  @doc false
  def changeset(equipment_trait, attrs) do
    equipment_trait
    |> cast(attrs, [:equipment_id, :trait_id])
    |> validate_required([:equipment_id, :trait_id])
    |> assoc_constraint(:equipment)
    |> assoc_constraint(:trait)
  end
end
