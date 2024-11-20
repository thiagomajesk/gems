defmodule GEMS.Engine.Schema.EquipmentType do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]

  schema "equipment_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(equipment_type, attrs) do
    equipment_type
    |> cast(attrs, @required_fields ++ [:description, :icon])
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
