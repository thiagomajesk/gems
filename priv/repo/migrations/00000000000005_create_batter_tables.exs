defmodule GEMS.Repo.Migrations.CreateBattlerTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Battles
    ################################################################################

    create table(:battles) do
      # PVE / PVP
      add :type, :string, null: false

      # JSON list that contains the list of turns and each turn contains only the state of the actors
      # There's no need to save everything we have in memory once the battle is over because the player only needs to see the diffs.
      add :turns, :map, null: false

      timestamps(updated_at: false)
    end
  end
end
