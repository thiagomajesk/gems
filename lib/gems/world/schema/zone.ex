defmodule GEMS.World.Schema.Zone do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :skull, :biome_id],
    optional_fields: [:description, :icon, :danger, :starting, :nearby_id]

  @skulls [:blue, :yellow, :red, :black]

  schema "zones" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
    field :skull, Ecto.Enum, values: @skulls
    field :danger, :integer
    field :starting, :boolean

    belongs_to :biome, GEMS.Engine.Schema.Biome
    belongs_to :faction, GEMS.World.Schema.Faction
    belongs_to :nearby, GEMS.World.Schema.Zone

    has_many :activities, GEMS.World.Schema.Activity

    many_to_many :creatures, GEMS.Engine.Schema.Creature,
      join_through: "zones_creatures",
      on_replace: :delete
  end

  def build_changeset(zone, attrs, opts) do
    changeset = super(zone, attrs, opts)

    changeset
    |> cast_assoc(:creatures, sort_param: :creatures_sort, drop_param: :creatures_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
