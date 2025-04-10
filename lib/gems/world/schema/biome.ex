defmodule GEMS.World.Schema.Biome do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "biomes" do
    field :name, :string
    field :code, :string
    field :description, :string
  end

  def build_changeset(biome, attrs, opts) do
    changeset = super(biome, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
