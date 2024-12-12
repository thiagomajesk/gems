defmodule GEMS.Repo.Migrations.CreateSharedTypesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Elements
    ################################################################################

    create table(:elements) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:elements, :name)
    create unique_index(:elements, :code)

    ################################################################################
    # Biomes
    ################################################################################

    create table(:biomes) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true

      add :affinity_id, references(:elements), null: true
      add :aversion_id, references(:elements), null: true
    end

    create unique_index(:biomes, :name)
    create unique_index(:biomes, :code)

    ################################################################################
    # Ability Types
    ################################################################################

    create table(:ability_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:ability_types, :name)
    create unique_index(:ability_types, :code)

    ################################################################################
    # Item Types
    ################################################################################

    create table(:item_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:item_types, :name)
    create unique_index(:item_types, :code)

    ################################################################################
    # Equipment Types
    ################################################################################

    create table(:equipment_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:equipment_types, :name)
    create unique_index(:equipment_types, :code)

    ################################################################################
    # Creature Types
    ################################################################################

    create table(:creature_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:creature_types, :name)
    create unique_index(:creature_types, :code)
  end
end
