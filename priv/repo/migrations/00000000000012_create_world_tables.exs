defmodule GEMS.Repo.Migrations.CreateWorldTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Professions
    ################################################################################

    create table(:professions) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :type, :string, null: false
      add :icon, :string, null: true
    end

    create unique_index(:professions, :name)
    create unique_index(:professions, :code)

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
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:factions, :name)

    ################################################################################
    # Zones
    ################################################################################

    create table(:zones) do
      add :name, :string, null: false
      add :code, :string, null: false
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
    create unique_index(:zones, :code)

    ################################################################################
    # Zones Gathering Options
    ################################################################################

    create table(:zones_gathering_options) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    # create constraint(:zones_gathering_options, :check_item_purpose,
    #          check: "check_reference_column_matches('items', 'purpose', 'gatherable')"
    #        )

    ################################################################################
    # Zones Gathering Options Requirements
    ################################################################################

    create table(:zones_gathering_options_requirements, primary_key: false) do
      add :zone_gathering_option_id, references(:zones_gathering_options),
        null: false,
        primary_key: true

      add :profession_id, references(:professions), null: false, primary_key: true
      add :required_level, :integer, null: false
    end

    ################################################################################
    # Zones Crafting Options
    ################################################################################

    create table(:zones_crafting_options) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    # create constraint(:zones_crafting_options, :check_item_purpose,
    #          check: "check_reference_column_matches('items', 'purpose', 'craftable')"
    #        )

    ################################################################################
    # Zones Crafting Options Requirements
    ################################################################################

    create table(:zones_crafting_options_requirements, primary_key: false) do
      add :zone_crafting_option_id, references(:zones_crafting_options),
        null: false,
        primary_key: true

      add :profession_id, references(:professions), null: false, primary_key: true
      add :required_level, :integer, null: false
    end

    ################################################################################
    # Zones Farming Options
    ################################################################################

    create table(:zones_farming_options) do
      add :zone_id, references(:zones), null: false
      add :item_id, references(:items), null: false
    end

    # create constraint(:zones_farming_options, :check_item_purpose,
    #          check: "check_reference_column_matches('items', 'purpose', 'farmable')"
    #        )

    ################################################################################
    # Zones Farming Options Requirements
    ################################################################################

    create table(:zones_farming_options_requirements, primary_key: false) do
      add :zone_farming_option_id, references(:zones_farming_options),
        null: false,
        primary_key: true

      add :profession_id, references(:professions), null: false, primary_key: true
      add :required_level, :integer, null: false
    end

    ################################################################################
    # Zones Combat Options
    ################################################################################

    create table(:zones_combat_options) do
      add :zone_id, references(:zones), null: false
      add :creature_id, references(:creatures), null: false
    end

    ################################################################################
    # Zones Combat Options Requirements
    ################################################################################

    create table(:zones_combat_options_requirements, primary_key: false) do
      add :zone_combat_option_id, references(:zones_combat_options),
        null: false,
        primary_key: true

      add :profession_id, references(:professions), null: false, primary_key: true
      add :required_level, :integer, null: false
    end
  end
end
