defmodule GEMS.Repo.Migrations.CreateZonesTable do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :biome, :string, null: false
      add :skull, :string, null: false
      add :danger, :integer, null: false, default: 1

      add :gathering_boost, :float, null: false, default: 0.0
      add :farming_boost, :float, null: false, default: 0.0
      add :crafting_boost, :float, null: false, default: 0.0

      add :faction_id, references(:factions), null: true
    end

    create unique_index(:zones, :name)
  end
end
