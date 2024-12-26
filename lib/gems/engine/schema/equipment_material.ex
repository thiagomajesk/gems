defmodule GEMS.Engine.Schema.EquipmentMaterial do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:amount, :equipment_id, :material_id]

  schema "equipments_materials" do
    field :amount, :integer

    belongs_to :equipment, GEMS.Engine.Schema.Equipment, primary_key: true
    belongs_to :material, GEMS.Engine.Schema.Item, primary_key: true
  end

  @doc false
  def changeset(equipment_material, attrs) do
    equipment_material
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
