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
      add :health_cost, :integer, null: false, default: 0
      add :energy_cost, :integer, null: false, default: 0

      add :target_side, :string, null: true
      add :target_filter, :string, null: true
      add :target_number, :integer, null: false, default: 1
      add :random_targets, :integer, null: false, default: 0

      add :hit_type, :string, null: true
      add :success_rate, :float, default: 1.0
      add :repeats, :integer, null: false, default: 1

      add :messages, :map, null: true
    end

    create unique_index(:skills, :code)

    ################################################################################
    # Classes
    ################################################################################

    create table(:classes) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :strength_curve, :map, null: false
      add :dexterity_curve, :map, null: false
      add :intelligence_curve, :map, null: false
    end

    create unique_index(:classes, :name)
    create unique_index(:classes, :code)

    ################################################################################
    # Creatures
    ################################################################################

    create table(:creatures) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
      add :type_id, references(:creature_types), null: false

      add :physical_resistance, :integer, default: 0
      add :maximum_health, :integer, default: 0
      add :health_regeneration, :integer, default: 0
      add :physical_damage, :integer, default: 0
      add :physical_power, :integer, default: 0

      add :evasion_rating, :integer, default: 0
      add :attack_speed, :integer, default: 0
      add :critical_rating, :integer, default: 0
      add :accuracy_rating, :integer, default: 0
      add :critical_power, :integer, default: 0

      add :magical_resistance, :integer, default: 0
      add :maximum_energy, :integer, default: 0
      add :energy_regeneration, :integer, default: 0
      add :magical_damage, :integer, default: 0
      add :magical_power, :integer, default: 0

      add :recovery_rating, :integer, default: 0
      add :fortitude_rating, :integer, default: 0
      add :critical_resistance, :integer, default: 0
      add :damage_penetration, :integer, default: 0
      add :damage_reflection, :integer, default: 0
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

      add :target_side, :string, null: true
      add :target_filter, :string, null: true
      add :target_number, :integer, null: false, default: 1
      add :random_targets, :integer, null: false, default: 0

      add :hit_type, :string, null: true
      add :success_rate, :float, default: 1.0
      add :repeats, :integer, null: false, default: 1

      add :messages, :map, null: true
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

      add :physical_resistance_bonus, :float, default: 0
      add :maximum_health_bonus, :float, default: 0
      add :health_regeneration_bonus, :float, default: 0
      add :physical_damage_bonus, :float, default: 0
      add :physical_power_bonus, :float, default: 0

      add :evasion_rating_bonus, :float, default: 0
      add :attack_speed_bonus, :float, default: 0
      add :critical_rating_bonus, :float, default: 0
      add :accuracy_rating_bonus, :float, default: 0
      add :critical_power_bonus, :float, default: 0

      add :magical_resistance_bonus, :float, default: 0
      add :maximum_energy_bonus, :float, default: 0
      add :energy_regeneration_bonus, :float, default: 0
      add :magical_damage_bonus, :float, default: 0
      add :magical_power_bonus, :float, default: 0

      add :recovery_rating_bonus, :float, default: 0
      add :fortitude_rating_bonus, :float, default: 0
      add :critical_resistance_bonus, :float, default: 0
      add :damage_penetration_bonus, :float, default: 0
      add :damage_reflection_bonus, :float, default: 0

      add :fire_damage_bonus, :float, default: 0
      add :fire_resistance_bonus, :float, default: 0
      add :water_damage_bonus, :float, default: 0
      add :water_resistance_bonus, :float, default: 0
      add :earth_damage_bonus, :float, default: 0
      add :earth_resistance_bonus, :float, default: 0
      add :air_damage_bonus, :float, default: 0
      add :air_resistance_bonus, :float, default: 0
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
    ################################################################################

    create table(:action_patterns) do
      add :kind, :string, null: false
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
      add :item_id, references(:items), null: true
      add :skill_id, references(:skills), null: true
    end

    create constraint(:action_patterns, :action_pattern_kind_matches,
             check: "(kind = 'item' AND item_id IS NOT NULL)
             OR (kind = 'skill' AND skill_id IS NOT NULL)"
           )

    ################################################################################
    # Creatures Action Patterns
    ################################################################################

    create table(:creatures_action_patterns, primary_key: false) do
      add :creature_id, references(:creatures), null: false, primary_key: true
      add :action_pattern_id, references(:action_patterns), null: false, primary_key: true
    end
  end
end
