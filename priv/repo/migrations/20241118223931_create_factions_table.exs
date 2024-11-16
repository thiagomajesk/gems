defmodule GEMS.Repo.Migrations.CreateFactionsTable do
  use Ecto.Migration

  def change do
    create table(:factions) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
    end

    create unique_index(:factions, :name)
  end
end
