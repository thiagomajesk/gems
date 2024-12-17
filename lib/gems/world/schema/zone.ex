defmodule GEMS.World.Schema.Zone do
  use GEMS.Database.Schema, :resource

  @skulls [:blue, :yellow, :red, :black]

  @required_fields [:name, :biome, :skull, :biome_id]
  @optional_fields [:description, :danger, :gathering_boost, :farming_boost, :crafting_boost]

  schema "zones" do
    field :name, :string
    field :description, :string
    belongs_to :biome, GEMS.Engine.Schema.Biome
    field :skull, Ecto.Enum, values: @skulls
    field :danger, :integer
    field :gathering_boost, :float
    field :farming_boost, :float
    field :crafting_boost, :float

    belongs_to :faction, GEMS.Engine.Schema.Faction
  end

  @doc false
  def changeset(zone, attrs) do
    build_changeset(zone, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(zone, attrs) do
    build_changeset(
      zone,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(zone, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    zone
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
