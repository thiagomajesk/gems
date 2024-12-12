defmodule GEMS.Engine.Schema.Biome do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]

  @optional_fields [:description, :icon, :affinity_id, :aversion_id]

  schema "biomes" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string

    belongs_to :affinity, GEMS.Engine.Schema.Element
    belongs_to :aversion, GEMS.Engine.Schema.Element
  end

  @doc false
  def changeset(biome, attrs) do
    build_changeset(biome, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(biome, attrs) do
    build_changeset(
      biome,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(biome, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    biome
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
