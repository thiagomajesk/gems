defmodule GEMS.Repo.Migrations.CreateWorldTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Avatars
    ################################################################################

    create table(:avatars) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:avatars, :name)
    create unique_index(:avatars, :code)

    ################################################################################
    # Professions
    ################################################################################

    create table(:professions) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:professions, :name)
    create unique_index(:professions, :code)

    ################################################################################
    # Blessings
    ################################################################################

    create table(:blessings) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :icon, :string, null: true
      add :description, :string, null: true
      add :duration, :integer, null: false
    end

    create unique_index(:blessings, :code)

    ################################################################################
    # Pets
    ################################################################################

    create table(:pets) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :icon, :string, null: true
      add :description, :string, null: true
    end

    create unique_index(:pets, :code)

    ################################################################################
    # Pets Blessings
    ################################################################################

    create table(:pets_blessings, primary_key: false) do
      add :pet_id, references(:pets), null: false, primary_key: true
      add :blessing_id, references(:blessings), null: false
    end

    ################################################################################
    # Factions
    ################################################################################

    create table(:factions) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:factions, :name)
    create unique_index(:factions, :code)

    ################################################################################
    # Zones
    ################################################################################

    create table(:zones) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :skull, :string, null: false
      add :danger, :integer, null: false, default: 1
      add :starting, :boolean, null: false, default: false

      add :biome_id, references(:biomes), null: false
      add :faction_id, references(:factions), null: true
    end

    create unique_index(:zones, :name)
    create unique_index(:zones, :code)

    ################################################################################
    # Zones Creatures
    ################################################################################

    create table(:zones_creatures, primary_key: false) do
      add :zone_id, references(:zones), null: false, primary_key: true
      add :creature_id, references(:creatures), null: false
    end

    ################################################################################
    # Activities
    ################################################################################

    create table(:activities) do
      add :action, :string, null: false
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: true
      add :profession_id, references(:professions), null: false
      add :required_level, :integer, null: false
    end
  end
end
