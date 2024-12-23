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

      add :max_health, :integer, null: false
      add :max_energy, :integer, null: false

      add :avatar_id, references(:avatars), null: false
      add :faction_id, references(:factions), null: false
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
      add :exp, :integer, default: 0
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
    end

    ################################################################################
    # Character Satchels
    ################################################################################

    create table(:characters_satchels, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :item_a_id, references(:items), null: false, primary_key: true
      add :item_b_id, references(:items), null: false, primary_key: true
      add :item_c_id, references(:items), null: false, primary_key: true
      add :item_d_id, references(:items), null: false, primary_key: true
      add :item_e_id, references(:items), null: false, primary_key: true
      add :item_f_id, references(:items), null: false, primary_key: true
    end

    ################################################################################
    # Loadouts
    ################################################################################

    create table(:characters_loadouts, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :name, :string, null: false
      add :icon, :string, null: false
      add :active, :boolean, null: false
      add :trinket, references(:equipments), null: true
      add :helmet, references(:equipments), null: true
      add :cape, references(:equipments), null: true
      add :main_hand, references(:equipments), null: true
      add :armor, references(:equipments), null: true
      add :ofF_hand, references(:equipments), null: true
      add :ring, references(:equipments), null: true
      add :boots, references(:equipments), null: true
      add :amulet, references(:equipments), null: true
    end

    create unique_index(:characters_loadouts, [:character_id, :name])
    create unique_index(:characters_loadouts, [:character_id, :active])

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
