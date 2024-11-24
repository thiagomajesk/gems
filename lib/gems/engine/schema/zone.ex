defmodule GEMS.Engine.Schema.Zone do
  use GEMS.Database.Schema, :resource

  @skulls [:blue, :yellow, :red, :black]

  @required_fields [:name, :biome, :skull, :biome_id]
  @option_fields [:description, :danger, :gathering_boost, :farming_boost, :crafting_boost]

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

  def changeset(zone, attrs) do
    zone
    |> cast(attrs, @required_fields ++ @option_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
