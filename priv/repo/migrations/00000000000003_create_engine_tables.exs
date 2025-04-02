defmodule GEMS.Repo.Migrations.CreateStatesTable do
  use Ecto.Migration

  def change do
    ################################################################################
    # Skills
    ################################################################################

    create table(:skills) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :icon, :map, null: true

      add :type_id, references(:skill_types), null: false
      add :health_cost, :integer, null: false
      add :energy_cost, :integer, null: false
      add :affinity, :string, null: false
      add :target_side, :string, null: false
      add :target_number, :integer, null: false
      add :random_targets, :integer, null: false

      add :effects, :map, null: true
    end

    create unique_index(:skills, :code)

    ################################################################################
    # Classes
    ################################################################################

    create table(:classes) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true

      add :base_maximum_health, :integer, null: false, default: 0
      add :base_maximum_energy, :integer, null: false, default: 0
      add :base_health_regeneration, :integer, null: false, default: 0
      add :base_energy_regeneration, :integer, null: false, default: 0
      add :base_physical_armor, :integer, null: false, default: 0
      add :base_magical_armor, :integer, null: false, default: 0
      add :base_attack_speed, :integer, null: false, default: 0
      add :base_accuracy_rating, :integer, null: false, default: 0
      add :base_evasion_rating, :integer, null: false, default: 0
      add :base_critical_rating, :integer, null: false, default: 0
      add :base_recovery_rating, :integer, null: false, default: 0
      add :base_fortitude_rating, :integer, null: false, default: 0
      add :base_damage_penetration, :integer, null: false, default: 0
      add :base_damage_reflection, :integer, null: false, default: 0
    end

    create unique_index(:classes, :name)
    create unique_index(:classes, :code)

    ################################################################################
    # Talents
    ################################################################################

    create table(:talents) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true

      add :class_id, references(:classes), null: false

      add :maximum_health_bonus, :float, null: false, default: 0
      add :maximum_energy_bonus, :float, null: false, default: 0
      add :health_regeneration_bonus, :float, null: false, default: 0
      add :energy_regeneration_bonus, :float, null: false, default: 0
      add :physical_armor_bonus, :float, null: false, default: 0
      add :magical_armor_bonus, :float, null: false, default: 0
      add :attack_speed_bonus, :float, null: false, default: 0
      add :accuracy_rating_bonus, :float, null: false, default: 0
      add :evasion_rating_bonus, :float, null: false, default: 0
      add :critical_rating_bonus, :float, null: false, default: 0
      add :recovery_rating_bonus, :float, null: false, default: 0
      add :fortitude_rating_bonus, :float, null: false, default: 0
      add :damage_penetration_bonus, :float, null: false, default: 0
      add :damage_reflection_bonus, :float, null: false, default: 0
    end

    ################################################################################
    # Creatures
    ################################################################################

    create table(:creatures) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
      add :type_id, references(:creature_types), null: false

      add :maximum_health, :integer, null: false, default: 0
      add :maximum_energy, :integer, null: false, default: 0
      add :health_regeneration, :integer, null: false, default: 0
      add :energy_regeneration, :integer, null: false, default: 0
      add :physical_armor, :integer, null: false, default: 0
      add :magical_armor, :integer, null: false, default: 0
      add :attack_speed, :integer, null: false, default: 0
      add :accuracy_rating, :integer, null: false, default: 0
      add :evasion_rating, :integer, null: false, default: 0
      add :critical_rating, :integer, null: false, default: 0
      add :recovery_rating, :integer, null: false, default: 0
      add :fortitude_rating, :integer, null: false, default: 0
      add :damage_penetration, :integer, null: false, default: 0
      add :damage_reflection, :integer, null: false, default: 0

      add :fire_resistance, :integer, null: false, default: 0
      add :water_resistance, :integer, null: false, default: 0
      add :earth_resistance, :integer, null: false, default: 0
      add :air_resistance, :integer, null: false, default: 0
    end

    create unique_index(:creatures, :code)

    ################################################################################
    # Items
    ################################################################################

    create table(:items) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true

      add :type_id, references(:item_types), null: false
      add :tier, :string, null: false
      add :price, :integer, null: true
    end

    create unique_index(:items, :code)

    ################################################################################
    # Items Ingredients
    ################################################################################

    create table(:items_ingredients, primary_key: false) do
      add :item_id, references(:items), null: false, primary_key: true
      add :ingredient_id, references(:items), null: false, primary_key: true
      add :amount, :integer, null: false, default: 1
    end

    ################################################################################
    # Equipments
    ################################################################################

    create table(:equipments) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
      add :type_id, references(:equipment_types), null: false
      add :slot, :string, null: false
      add :tier, :string, null: false
      add :price, :integer, null: true
      add :affinity, :string, null: true

      add :maximum_health_bonus, :float, null: false, default: 0
      add :maximum_energy_bonus, :float, null: false, default: 0
      add :health_regeneration_bonus, :float, null: false, default: 0
      add :energy_regeneration_bonus, :float, null: false, default: 0
      add :physical_armor_bonus, :float, null: false, default: 0
      add :magical_armor_bonus, :float, null: false, default: 0
      add :attack_speed_bonus, :float, null: false, default: 0
      add :accuracy_rating_bonus, :float, null: false, default: 0
      add :evasion_rating_bonus, :float, null: false, default: 0
      add :critical_rating_bonus, :float, null: false, default: 0
      add :recovery_rating_bonus, :float, null: false, default: 0
      add :fortitude_rating_bonus, :float, null: false, default: 0
      add :damage_penetration_bonus, :float, null: false, default: 0
      add :damage_reflection_bonus, :float, null: false, default: 0

      add :fire_resistance_bonus, :float, null: false, default: 0
      add :water_resistance_bonus, :float, null: false, default: 0
      add :earth_resistance_bonus, :float, null: false, default: 0
      add :air_resistance_bonus, :float, null: false, default: 0
    end

    create unique_index(:equipments, :code)

    ################################################################################
    # Equipments Materials
    ################################################################################

    create table(:equipments_materials, primary_key: false) do
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :material_id, references(:items), null: false, primary_key: true
      add :amount, :integer, null: false, default: 1
    end

    ################################################################################
    # Action Patterns
    ################################################################################ s

    create table(:action_patterns) do
      add :condition, :string, null: false
      add :priority, :integer, null: false
      add :chance, :float, null: true
      add :start_turn, :integer, null: true
      add :every_turn, :integer, null: true
      add :min_health, :integer, null: true
      add :maximum_health, :integer, null: true
      add :min_energy, :integer, null: true
      add :maximum_energy, :integer, null: true
      add :state, :string, null: true
      add :skill_id, references(:skills), null: true
    end

    ################################################################################
    # Creatures Action Patterns
    ################################################################################

    create table(:creatures_action_patterns, primary_key: false) do
      add :creature_id, references(:creatures), null: false, primary_key: true
      add :action_pattern_id, references(:action_patterns), null: false, primary_key: true
    end
  end
end
