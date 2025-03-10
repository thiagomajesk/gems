defmodule GEMS.Repo.Migrations.CreateWorldTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Avatars
    ################################################################################

    create table(:avatars) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
    end

    create unique_index(:avatars, :name)
    create unique_index(:avatars, :code)

    ################################################################################
    # Professions
    ################################################################################

    create table(:professions) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :icon, :map, null: true
    end

    create unique_index(:professions, :name)
    create unique_index(:professions, :code)

    ################################################################################
    # Blessings
    ################################################################################

    create table(:blessings) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :icon, :map, null: true
      add :duration, :integer, null: true
    end

    create unique_index(:blessings, :code)

    ################################################################################
    # Pets
    ################################################################################

    create table(:pets) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
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
      add :description, :text, null: true
      add :icon, :map, null: true
    end

    create unique_index(:factions, :name)
    create unique_index(:factions, :code)

    ################################################################################
    # Biomes
    ################################################################################

    create table(:biomes) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true

      add :affinity_id, references(:elements), null: true
      add :aversion_id, references(:elements), null: true
    end

    create unique_index(:biomes, :name)
    create unique_index(:biomes, :code)

    ################################################################################
    # Zones
    ################################################################################

    create table(:zones) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
      add :skull, :string, null: false
      add :danger, :integer, null: false, default: 1
      add :starting, :boolean, null: false, default: false
      add :gold_cost, :integer, null: false, default: 0
      add :stamina_cost, :integer, null: false, default: 0

      add :biome_id, references(:biomes), null: false
      add :faction_id, references(:factions), null: true
    end

    create unique_index(:zones, :name)
    create unique_index(:zones, :code)

    ################################################################################
    # Portals
    ################################################################################

    create table(:portals, primary_key: false) do
      add :origin_id, references(:zones), null: false, primary_key: true
      add :target_id, references(:zones), null: false, primary_key: true
      add :direction, :string, null: false, primary_key: true
    end

    ################################################################################
    # Hunts
    ################################################################################

    create table(:hunts) do
      add :zone_id, references(:zones), null: false, primary_key: true
      add :creature_id, references(:creatures), null: false
      add :challenge, :integer, null: false, default: 1
    end

    ################################################################################
    # Activities
    ################################################################################

    create table(:activities) do
      add :zone_id, references(:zones), null: false
      add :action, :string, null: false
      add :duration, :integer, null: false, default: 0
      add :item_id, references(:items), null: true
      add :min_amount, :integer, null: false, default: 1, check: "min_amount >= 1"
      add :max_amount, :integer, null: false, default: 1, check: "max_amount >= min_amount"
      add :profession_id, references(:professions), null: false
      add :experience, :integer, null: false, default: 0
      add :required_level, :integer, null: false, default: 0
    end
  end
end
