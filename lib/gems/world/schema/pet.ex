defmodule GEMS.World.Schema.Pet do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name],
    optional_fields: [:icon, :description]

  schema "pets" do
    field :name, :string
    field :icon, :string
    field :description, :string

    many_to_many :blessings, GEMS.World.Schema.Blessing, join_through: "pets_blessings"
  end
end
