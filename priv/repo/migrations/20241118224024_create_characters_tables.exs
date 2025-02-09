defmodule GEMS.Repo.Migrations.CreateCharactersTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Characters
    ################################################################################

    create table(:characters) do
      add :name, :string, null: false
      add :title, :string, null: true
      add :bio, :string, null: true

      add :level, :integer, null: false, default: 1
      add :experience, :integer, null: false, default: 0
      add :souls, :integer, null: false, default: 1

      add :avatar_id, references(:avatars), null: false
      add :faction_id, references(:factions), null: false
      add :origin_id, references(:origins), null: false
      add :zone_id, references(:zones), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:characters, :name)

    ################################################################################
    # Characters Professions
    ################################################################################

    create table(:characters_professions, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :profession_id, references(:professions), null: false, primary_key: true
      add :level, :integer, default: 0
      add :experience, :integer, default: 0
    end

    ################################################################################
    # Characters Items
    ################################################################################

    create table(:characters_items, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :item_id, references(:items), null: false, primary_key: true
      add :amount, :integer, null: false, default: 1
    end

    ################################################################################
    # Characters Equipments
    ################################################################################

    create table(:characters_equipments, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :level, :integer, null: false, default: 1
      add :experience, :integer, null: false, default: 0
    end

    ################################################################################
    # Characters Satchels
    ################################################################################

    create table(:characters_satchels, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :item_id, references(:items), null: false, primary_key: true
      add :slot, :integer, null: false, primary_key: true
      add :amount, :integer, null: false, default: 1
    end

    ################################################################################
    # Characters Apparels
    ################################################################################

    create table(:characters_apparels, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :slot, :integer, null: false, primary_key: true
    end

    ################################################################################
    # Characters Blessings
    ################################################################################

    create table(:characters_blessings, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :blessing_id, references(:blessings), null: false, primary_key: true
    end

    ################################################################################
    # Characters Pets
    ################################################################################

    create table(:characters_pets, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :pet_id, references(:pets), null: false, primary_key: true
    end
  end
end
