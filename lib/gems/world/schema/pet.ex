defmodule GEMS.World.Schema.Pet do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name],
    optional_fields: [:description, :image]

  schema "pets" do
    field :name, :string
    field :description, :string
    field :image, :string

    many_to_many :blessings, GEMS.World.Schema.Blessing, join_through: "pets_blessings"
  end
end
