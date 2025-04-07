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
      add :target_scope, :string, null: false
      add :target_number, :integer, null: false
      add :random_targets, :integer, null: false
      add :critical_hits, :boolean, null: false

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

      add :damage, :integer, null: false
      add :accuracy, :float, null: false
      add :evasion, :float, null: false
      add :fortitude, :float, null: false
      add :recovery, :float, null: false
      add :maximum_health, :integer, null: false
      add :maximum_energy, :integer, null: false
      add :physical_armor, :integer, null: false
      add :magical_armor, :integer, null: false
      add :attack_speed, :integer, null: false
      add :critical_chance, :float, null: false
      add :critical_multiplier, :float, null: false
      add :damage_penetration, :integer, null: false
      add :damage_reflection, :integer, null: false
      add :health_regeneration, :float, null: false
      add :energy_regeneration, :float, null: false
      add :fire_resistance, :float, null: false
      add :water_resistance, :float, null: false
      add :earth_resistance, :float, null: false
      add :air_resistance, :float, null: false
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

      add :damage, :integer, null: false
      add :accuracy, :float, null: false
      add :evasion, :float, null: false
      add :fortitude, :float, null: false
      add :recovery, :float, null: false
      add :maximum_health, :integer, null: false
      add :maximum_energy, :integer, null: false
      add :physical_armor, :integer, null: false
      add :magical_armor, :integer, null: false
      add :attack_speed, :integer, null: false
      add :critical_chance, :float, null: false
      add :critical_multiplier, :float, null: false
      add :damage_penetration, :integer, null: false
      add :damage_reflection, :integer, null: false
      add :health_regeneration, :float, null: false
      add :energy_regeneration, :float, null: false
      add :fire_resistance, :float, null: false
      add :water_resistance, :float, null: false
      add :earth_resistance, :float, null: false
      add :air_resistance, :float, null: false
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

      add :damage, :integer, null: false
      add :accuracy, :float, null: false
      add :evasion, :float, null: false
      add :fortitude, :float, null: false
      add :recovery, :float, null: false
      add :maximum_health, :integer, null: false
      add :maximum_energy, :integer, null: false
      add :physical_armor, :integer, null: false
      add :magical_armor, :integer, null: false
      add :attack_speed, :integer, null: false
      add :critical_chance, :float, null: false
      add :critical_multiplier, :float, null: false
      add :damage_penetration, :integer, null: false
      add :damage_reflection, :integer, null: false
      add :health_regeneration, :float, null: false
      add :energy_regeneration, :float, null: false
      add :fire_resistance, :float, null: false
      add :water_resistance, :float, null: false
      add :earth_resistance, :float, null: false
      add :air_resistance, :float, null: false
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

      add :damage, :integer, null: false
      add :accuracy, :float, null: false
      add :evasion, :float, null: false
      add :fortitude, :float, null: false
      add :recovery, :float, null: false
      add :maximum_health, :integer, null: false
      add :maximum_energy, :integer, null: false
      add :physical_armor, :integer, null: false
      add :magical_armor, :integer, null: false
      add :attack_speed, :integer, null: false
      add :critical_chance, :float, null: false
      add :critical_multiplier, :float, null: false
      add :damage_penetration, :integer, null: false
      add :damage_reflection, :integer, null: false
      add :health_regeneration, :float, null: false
      add :energy_regeneration, :float, null: false
      add :fire_resistance, :float, null: false
      add :water_resistance, :float, null: false
      add :earth_resistance, :float, null: false
      add :air_resistance, :float, null: false
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
      add :trigger, :string, null: false
      add :priority, :integer, null: false
      add :chance, :float, null: true
      add :start_turn, :integer, null: true
      add :every_turn, :integer, null: true
      add :minimum_health, :integer, null: true
      add :maximum_health, :integer, null: true
      add :minimum_energy, :integer, null: true
      add :maximum_energy, :integer, null: true
      add :condition, :string, null: true
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
