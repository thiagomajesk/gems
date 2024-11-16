defmodule GEMS.Repo.Migrations.CreateEffectsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Recovery Options
    ################################################################################

    create table(:effects_recovery_options) do
      # Health, Energy
      add :parameter, :string, null: false
      add :percentage, :float, default: 0.0
      add :maximum, :integer, null: true
      add :fixed, :integer, nulll: true
      add :variance, :float, default: 0.0
    end

    ################################################################################
    # State Options
    ################################################################################

    create table(:effects_state_options) do
      # Add, Remove
      add :action, :string, null: false
      add :state_id, references(:states), null: false
      add :chance, :float, default: 0.0
    end

    ################################################################################
    # Parameter Options
    ################################################################################

    create table(:effects_parameter_options) do
      # Add, Remove
      add :change, :string, null: false
      add :parameter, :string, null: false
      add :turns, :integer, default: 0
      add :chance, :float, default: 0.0
    end

    ################################################################################
    # Effects
    ################################################################################

    create table(:effects) do
      add :scope_option_id, references(:scope_options), null: true
      add :recovery_option_id, references(:effects_recovery_options), null: true
      add :state_option_id, references(:effects_state_options), null: true
      add :parameter_option_id, references(:effects_parameter_options), null: true
    end
  end
end
