defmodule GEMS.Repo.Migrations.CreateStatesTable do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :priority, :integer, default: 100
      add :restriction, :string, null: true
    end

    create unique_index(:states, :code)
  end
end
