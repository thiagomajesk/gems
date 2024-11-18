defmodule GEMS.Engine.Schema.EquipmentType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipment_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(equipment_type, attrs) do
    equipment_type
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
