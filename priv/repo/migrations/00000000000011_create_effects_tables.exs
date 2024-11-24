defmodule GEMS.Repo.Migrations.CreateEffectsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Effects
    ################################################################################

    create table(:effects) do
      add :kind, :string, null: false
      add :item_id, references(:items)
      add :ability_id, references(:abilities)
    end

    create constraint(:effects, :single_association,
             check: "num_nonnulls(item_id, ability_id) = 1"
           )

    ################################################################################
    # Recoveries
    ################################################################################

    create table(:effects_recoveries) do
      add :effect_id, references(:effects, on_delete: :delete_all), null: false
      add :parameter, :string, null: false
      add :flat, :integer, default: 0, null: false
      add :rate, :float, default: 0.0
      add :variance, :float, null: false, default: 0.0
      add :maximum, :integer, null: true
    end

    create constraint(:effects_recoveries, :effect_kind_matches,
             check: "check_column_value(effect_id, 'effects', 'kind', 'recovery')"
           )

    ################################################################################
    # State Changes
    ################################################################################

    create table(:effects_state_changes) do
      add :effect_id, references(:effects, on_delete: :delete_all), null: false
      add :action, :string, null: false
      add :state_id, references(:states), null: false
      add :chance, :float, default: 0.0
    end

    create constraint(:effects_state_changes, :effect_kind_matches,
             check: "check_column_value(effect_id, 'effects', 'kind', 'state_change')"
           )

    ################################################################################
    # Parameter Changes
    ################################################################################

    create table(:effects_parameter_changes) do
      add :effect_id, references(:effects, on_delete: :delete_all), null: false
      add :parameter, :string, null: false
      add :type, :string, null: false
      add :action, :string, null: false
      add :turns, :integer, null: false, default: 1
    end

    create constraint(:effects_parameter_changes, :effect_kind_matches,
             check: "check_column_value(effect_id, 'effects', 'kind', 'parameter_change')"
           )
  end
end
