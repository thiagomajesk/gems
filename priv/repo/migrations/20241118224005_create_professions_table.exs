defmodule GEMS.Repo.Migrations.CreateProfessionsTable do
  use Ecto.Migration

  def change do
    create table(:professions) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :type, :string, null: false
      add :icon, :string, null: true
      add :max_level, :integer, default: 99
    end

    create unique_index(:professions, :name)
  end
end
