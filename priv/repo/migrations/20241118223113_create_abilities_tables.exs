defmodule GEMS.Repo.Migrations.CreateAbilitiesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Abilities
    ################################################################################

    create table(:abilities) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :type_id, references(:ability_types), null: false
      add :health_cost, :integer, null: false, default: 0
      add :energy_cost, :integer, null: false, default: 0

      add :activation_option_id, references(:activation_options), null: false
      add :damage_option_id, references(:damage_options), null: false

      add :messages, :map, null: true
    end

    create unique_index(:abilities, :name)

    ################################################################################
    # Abilities Effects
    ################################################################################

    create table(:abilities_effects, primary_key: false) do
      add :ability_id, references(:abilities), null: false, primary_key: true
      add :effect_id, references(:effects), null: false, primary_key: true
    end
  end
end
