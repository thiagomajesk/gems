defmodule GEMS.Engine.Schema.Biome do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name, :code],
    optional_fields: [
      :description,
      :icon,
      :affinity_id,
      :aversion_id
    ]

  schema "biomes" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string

    belongs_to :affinity, GEMS.Engine.Schema.Element
    belongs_to :aversion, GEMS.Engine.Schema.Element
  end

  def build_changeset(biome, attrs, opts) do
    changeset = super(biome, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
