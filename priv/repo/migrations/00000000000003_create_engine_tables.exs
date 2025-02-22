defmodule GEMS.Repo.Migrations.CreateStatesTable do
  use Ecto.Migration

  def change do
    ################################################################################
    # States
    ################################################################################

    create table(:states) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :icon, :map, null: true
      add :priority, :integer, default: 100
      add :restriction, :string, null: true
    end

    create unique_index(:states, :code)

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
    # Abilities
    ################################################################################

    create table(:skills) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :icon, :map, null: true
      add :type_id, references(:skill_types), null: false
      add :health_cost, :integer, null: false, default: 0
      add :mana_cost, :integer, null: false, default: 0

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

    create unique_index(:skills, :code)

    ################################################################################
    # Creatures
    ################################################################################

    create table(:creatures) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :text, null: true
      add :image, :string, null: true
      add :type_id, references(:creature_types), null: false

      # STR
      add :armor_rating, :integer, default: 0
      add :max_health, :integer, default: 0
      add :health_regen, :integer, default: 0
      add :attack_damage, :integer, default: 0
      add :weapon_power, :integer, default: 0

      # DEX
      add :evasion_rating, :integer, default: 0
      add :attack_speed, :integer, default: 0
      add :critical_rating, :integer, default: 0
      add :accuracy_rating, :integer, default: 0
      add :critical_power, :integer, default: 0

      # INT
      add :magic_resist, :integer, default: 0
      add :max_mana, :integer, default: 0
      add :mana_regen, :integer, default: 0
      add :magic_damage, :integer, default: 0
      add :skill_power, :integer, default: 0
    end

    create unique_index(:creatures, :code)

    ################################################################################
    # Creature Action Patterns
    ################################################################################

    create table(:creature_action_patterns, primary_key: false) do
      add :creature_id, references(:creatures), null: false
      add :skill_id, references(:skills), null: false
      add :priority, :integer, null: false, default: 0
      add :condition, :string, null: false
      add :min_turn, :integer, null: true
      add :max_turn, :integer, null: true
      add :min_health, :integer, null: true
      add :max_health, :integer, null: true
      add :min_mana, :integer, null: true
      add :max_mana, :integer, null: true
      add :state_id, references(:states), null: true
    end

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

      # STR
      add :armor_rating, :integer, default: 0
      add :max_health, :integer, default: 0
      add :health_regen, :integer, default: 0
      add :attack_damage, :integer, default: 0
      add :weapon_power, :integer, default: 0

      # DEX
      add :evasion_rating, :integer, default: 0
      add :attack_speed, :integer, default: 0
      add :critical_rating, :integer, default: 0
      add :accuracy_rating, :integer, default: 0
      add :critical_power, :integer, default: 0

      # INT
      add :magic_resist, :integer, default: 0
      add :max_mana, :integer, default: 0
      add :mana_regen, :integer, default: 0
      add :magic_damage, :integer, default: 0
      add :skill_power, :integer, default: 0
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
  end
end
