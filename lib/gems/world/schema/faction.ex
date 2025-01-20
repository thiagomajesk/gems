defmodule GEMS.World.Schema.Faction do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :icon]

  schema "factions" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end
end
