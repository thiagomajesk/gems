defmodule GEMS.Repo.Migrations.CreateSharedOptionsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Activation Options
    ################################################################################

    create table(:activation_options) do
      # Physical Attack, Magical Attack, Certain Hit
      add :hit_type, :string, null: false
      add :success_rate, :float, default: 1.0
      add :repeats, :integer, null: false, default: 1
    end

    ################################################################################
    # Damage Options
    ################################################################################

    create table(:damage_options) do
      # Health, Energy, Health Recover, Energy Recover, Health Drain, Energy Drain
      add :damage_type, :text, null: false
      add :element_id, references(:elements), null: false
      add :formula, :text, null: true
      add :variance, :float, null: false, default: 0.0
      add :critical_hits, :boolean, null: false, default: false
    end

    ################################################################################
    # Scope Options
    ################################################################################

    create table(:scope_options) do
      # Enemy, Ally, Both, Self
      add :target_side, :string, null: false
      # Any, Alive, Dead
      add :target_status, :string, null: false
      # One, All, Random
      add :target_number, :string, null: false
      add :random_targets, :integer, default: 0
    end
  end
end
