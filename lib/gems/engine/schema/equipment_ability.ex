defmodule GEMS.Engine.Schema.EquipmentAbility do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipments_abilities" do
    belongs_to :equipment, GEMS.Engine.Schema.Equipment
    belongs_to :ability, GEMS.Engine.Schema.Ability
  end

  @doc false
  def changeset(equipment_ability, attrs) do
    equipment_ability
    |> cast(attrs, [:equipment_id, :ability_id])
    |> validate_required([:equipment_id, :ability_id])
    |> assoc_constraint(:equipment)
    |> assoc_constraint(:ability)
  end
end
