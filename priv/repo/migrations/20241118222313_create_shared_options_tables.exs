defmodule GEMS.Repo.Migrations.CreateSharedOptionsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Activation Options
    ################################################################################

    create table(:activation_options) do
      add :hit_type, :string, null: false
      add :success_rate, :float, default: 1.0
      add :repeats, :integer, null: false, default: 1
    end

    ################################################################################
    # Damage Options
    ################################################################################

    create table(:damage_options) do
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
      add :target_side, :string, null: false
      add :target_status, :string, null: false
      add :target_number, :string, null: false
      add :random_targets, :integer, null: true
    end

    create constraint(:scope_options, :check_random_targets_filled,
             check: "NOT (target_number = 'Random' AND random_targets IS NULL)"
           )
  end
end
