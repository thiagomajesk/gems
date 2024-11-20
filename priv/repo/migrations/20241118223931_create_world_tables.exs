defmodule GEMS.Repo.Migrations.CreateWorldTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Professions
    ################################################################################

    create table(:professions) do
      add :name, :string, null: false
      add :description, :string, null: true
      # Gathering, Crafting, Farming, Combat
      add :type, :string, null: false
      add :icon, :string, null: true
      add :max_level, :integer, default: 99
    end

    create unique_index(:professions, :name)

    ################################################################################
    # Guilds
    ################################################################################

    create table(:guilds) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:guilds, :name)

    ################################################################################
    # Blessings
    ################################################################################

    create table(:blessings) do
      add :name, :string, null: false
      add :icon, :string, null: true
      add :description, :string, null: true
      add :duration, :utc_datetime, null: false
    end

    create unique_index(:blessings, :name)

    ################################################################################
    # Blessings Traits
    ################################################################################

    create table(:blessings_traits, primary_key: false) do
      add :blessing_id, references(:blessings), null: false, primary_key: true
      add :trait_id, references(:traits), null: false, primary_key: true
    end

    ################################################################################
    # Pets
    ################################################################################

    create table(:pets) do
      add :name, :string, null: false
      add :icon, :string, null: true
      add :description, :string, null: true
    end

    create unique_index(:pets, :name)

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
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:factions, :name)

    ################################################################################
    # Zones
    ################################################################################

    create table(:zones) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :skull, :string, null: false
      add :danger, :integer, null: false, default: 1

      add :gathering_boost, :float, null: false, default: 0.0
      add :farming_boost, :float, null: false, default: 0.0
      add :crafting_boost, :float, null: false, default: 0.0

      add :biome_id, references(:biomes), null: false
      add :faction_id, references(:factions), null: true
    end

    create unique_index(:zones, :name)

    ################################################################################
    # Zones Gathering Options
    ################################################################################

    create table(:zones_gathering_options, primary_key: false) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    ################################################################################
    # Zones Crafting Options
    ################################################################################

    create table(:zones_crafting_options, primary_key: false) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    ################################################################################
    # Zones Farming Options
    ################################################################################

    create table(:zones_farming_options, primary_key: false) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    ################################################################################
    # Zones Combat Options
    ################################################################################

    create table(:zones_combat_options, primary_key: false) do
      add :zone_id, references(:zones), null: false
      add :creature_id, references(:creatures), null: false
    end
  end
end
