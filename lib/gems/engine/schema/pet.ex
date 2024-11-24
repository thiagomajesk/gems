defmodule GEMS.Engine.Schema.Pet do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:icon, :description]

  schema "pets" do
    field :name, :string
    field :icon, :string
    field :description, :string

    many_to_many :blessings, GEMS.Engine.Schema.Blessing, join_through: "pets_blessings"
  end

  def changeset(pet, attrs) do
    pet
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
