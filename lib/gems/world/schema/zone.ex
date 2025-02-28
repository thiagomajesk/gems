defmodule GEMS.World.Schema.Zone do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :skull, :biome_id],
    optional_fields: [
      :description,
      :image,
      :danger,
      :starting,
      :gold_cost,
      :stamina_cost,
      :faction_id
    ],
    default_preloads: [
      :biome,
      :faction,
      :portals,
      activities: [:profession, :item]
    ]

  @skulls [:blue, :yellow, :red, :black]

  schema "zones" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :skull, Ecto.Enum, values: @skulls
    field :danger, :integer
    field :starting, :boolean
    field :gold_cost, :integer
    field :stamina_cost, :integer

    belongs_to :biome, GEMS.World.Schema.Biome
    belongs_to :faction, GEMS.World.Schema.Faction

    has_many :portals, GEMS.World.Schema.Portal, foreign_key: :origin_id, on_replace: :delete
    has_many :activities, GEMS.World.Schema.Activity, on_replace: :delete

    many_to_many :creatures, GEMS.Engine.Schema.Creature,
      join_through: "zones_creatures",
      on_replace: :delete
  end

  def build_changeset(zone, attrs, opts) do
    changeset = super(zone, attrs, opts)

    changeset
    |> cast_assoc(:portals, sort_param: :portals_sort, drop_param: :portals_drop)
    |> cast_assoc(:activities, sort_param: :activities_sort, drop_param: :activities_drop)
    |> cast_assoc(:creatures, sort_param: :creatures_sort, drop_param: :creatures_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
