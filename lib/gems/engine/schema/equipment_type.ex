defmodule GEMS.Engine.Schema.EquipmentType do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name, :code],
    optional_fields: [:description, :icon]

  schema "equipment_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  def build_changeset(equipment_type, attrs, opts) do
    changeset = super(equipment_type, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
