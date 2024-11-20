defmodule GEMS.Engine.Schema.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :biome, :skull]

  schema "zones" do
    field :name, :string
    field :description, :string
    belongs_to :biome, GEMS.Engine.Schema.Biome
    field :skull, :string
    field :danger, :integer
    field :gathering_boost, :float
    field :farming_boost, :float
    field :crafting_boost, :float
    belongs_to :faction, GEMS.Engine.Schema.Faction
  end

  def changeset(zone, attrs) do
    zone
    |> cast(attrs, [
      :name,
      :description,
      :biome,
      :skull,
      :danger,
      :gathering_boost,
      :farming_boost,
      :crafting_boost,
      :faction_id,
      :biome_id
    ])
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
