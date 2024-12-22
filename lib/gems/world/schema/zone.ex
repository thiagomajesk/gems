defmodule GEMS.World.Schema.Zone do
  use GEMS.Database.Schema, :resource

  @skulls [:blue, :yellow, :red, :black]

  @required_fields [:name, :code, :skull, :biome_id]
  @optional_fields [:description, :danger, :starting]

  schema "zones" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :skull, Ecto.Enum, values: @skulls
    field :danger, :integer
    field :starting, :boolean

    belongs_to :biome, GEMS.Engine.Schema.Biome
    belongs_to :faction, GEMS.World.Schema.Faction

    has_many :activities, GEMS.World.Schema.Activity

    many_to_many :creatures, GEMS.Engine.Schema.Creature,
      join_through: "zones_creatures",
      on_replace: :delete
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
    |> cast_assoc(:creatures, sort_param: :creatures_sort, drop_param: :creatures_drop)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
