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
    end

    create unique_index(:elements, :name)
    create unique_index(:elements, :code)

    ################################################################################
    # Skill Types
    ################################################################################

    create table(:skill_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
    end

    create unique_index(:skill_types, :name)
    create unique_index(:skill_types, :code)

    ################################################################################
    # Item Types
    ################################################################################

    create table(:item_types) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
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
    end

    create unique_index(:creature_types, :name)
    create unique_index(:creature_types, :code)
  end
end
