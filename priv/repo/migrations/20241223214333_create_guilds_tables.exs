defmodule GEMS.Repo.Migrations.CreateGuildsTables do
  use Ecto.Migration

  def change do
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
    # Guilds Memberships
    ################################################################################

    create table(:guilds_memberships, primary_key: false) do
      add :guild_id, references(:guilds), null: false, primary_key: true
      add :character_id, references(:characters), null: false
      add :role, :string, null: false
    end
  end
end
