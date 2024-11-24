defmodule GEMS.Engine.Schema.Biome do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:description, :icon, :affinity_id, :aversion_id]

  schema "biomes" do
    field :name, :string
    field :description, :string
    field :icon, :string

    belongs_to :affinity, GEMS.Engine.Schema.Element
    belongs_to :aversion, GEMS.Engine.Schema.Element
  end

  @doc false
  def changeset(biome, attrs) do
    biome
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
