defmodule GEMS.Engine.Schema.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :description, :string
    field :biome, :string
    field :skull, :string
    field :danger, :integer, default: 1
    field :gathering_boost, :float, default: 0.0
    field :farming_boost, :float, default: 0.0
    field :crafting_boost, :float, default: 0.0

    belongs_to :faction, GEMS.Engine.Schema.Faction
  end

  @doc false
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
      :faction_id
    ])
    |> validate_required([:name, :biome, :skull])
    |> unique_constraint(:name)
  end
end
