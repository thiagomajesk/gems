defmodule GEMS.Repo.Migrations.CreateSharedTypesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Elements
    ################################################################################

    create table(:elements) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:elements, :name)

    ################################################################################
    # Ability Types
    ################################################################################

    create table(:ability_types) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:ability_types, :name)

    ################################################################################
    # Item Types
    ################################################################################

    create table(:item_types) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:item_types, :name)

    ################################################################################
    # Equipment Types
    ################################################################################

    create table(:equipment_types) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:equipment_types, :name)
  end
end
