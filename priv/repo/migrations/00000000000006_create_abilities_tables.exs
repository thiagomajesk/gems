defmodule GEMS.Repo.Migrations.CreateAbilitiesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Abilities
    ################################################################################

    create table(:abilities) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :type_id, references(:ability_types), null: false
      add :health_cost, :integer, null: false, default: 0
      add :energy_cost, :integer, null: false, default: 0

      add :target_side, :string, null: true
      add :target_status, :string, null: true
      add :target_number, :integer, null: false, default: 1
      add :random_targets, :integer, null: false, default: 0

      add :hit_type, :string, null: true
      add :success_rate, :float, default: 1.0
      add :repeats, :integer, null: false, default: 1

      add :damage_type, :string, null: true

      add :damage_element_id, references(:elements, on_delete: :nilify_all), null: true

      add :damage_formula, :string, null: true
      add :damage_variance, :float, null: true
      add :critical_hits, :boolean, default: false

      add :messages, :map, null: true
    end

    create unique_index(:abilities, :code)
  end
end
