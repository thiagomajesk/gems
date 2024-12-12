defmodule GEMS.Engine.Schema.EquipmentType do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]
  @optional_fields [:description, :icon]

  schema "equipment_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(equipment_type, attrs) do
    equipment_type
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  @doc false
  def seed_changeset(equipment_type, attrs) do
    build_changeset(
      equipment_type,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(equipment_type, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    equipment_type
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
