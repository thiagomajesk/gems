defmodule GEMS.Engine.Schema.ItemType do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:description, :icon]

  schema "item_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  def changeset(item_type, attrs) do
    item_type
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
