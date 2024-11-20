defmodule GEMS.Repo.Migrations.CreateCreaturesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Creatures
    ################################################################################

    create table(:creatures) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :biome_id, references(:biomes), null: true

      add :max_health, :integer, null: false, default: 0
      add :max_energy, :integer, null: false, default: 0
      add :physical_damage, :integer, null: false, default: 0
      add :magical_damage, :integer, null: false, default: 0
      add :physical_defense, :integer, null: false, default: 0
      add :magical_defense, :integer, null: false, default: 0
      add :health_regen, :integer, null: false, default: 0
      add :energy_regen, :integer, null: false, default: 0
      add :accuracy, :integer, null: false, default: 0
      add :evasion, :integer, null: false, default: 0
      add :attack_speed, :integer, null: false, default: 0
      add :break_power, :integer, null: false, default: 0
      add :critical_rating, :integer, null: false, default: 0
      add :critical_power, :integer, null: false, default: 0
      add :weapon_power, :integer, null: false, default: 0
      add :ability_power, :integer, null: false, default: 0
      add :resilience, :integer, null: false, default: 0
      add :lehality, :integer, null: false, default: 0
    end

    create unique_index(:creatures, :name)

    ################################################################################
    # Creatures Traits
    ################################################################################

    create table(:creatures_traits, primary_key: false) do
      add :creature_id, references(:creatures), null: false, primary_key: true
      add :trait_id, references(:traits), null: false, primary_key: true
    end

    ################################################################################
    # Creatures Rewards
    ################################################################################

    create table(:creatures_rewards, primary_key: false) do
      add :creature_id, references(:creatures), null: false
      add :item_id, references(:items), null: false
      add :amount, :integer, null: false
      add :chance, :float, default: 0.0
    end

    create constraint(:creatures_rewards, :check_one_of_create_or_item,
             check: "num_nonnulls(creature_id, item_id) = 1"
           )

    ################################################################################
    # Creature Action Patterns
    ################################################################################

    create table(:creature_action_patterns, primary_key: false) do
      add :creature_id, references(:creatures), null: false
      add :ability_id, references(:abilities), null: false
      add :priority, :integer, null: false, default: 0
      add :condition, :string, null: false
      add :min_turn, :integer, null: true
      add :max_turn, :integer, null: true
      add :min_health, :integer, null: true
      add :max_health, :integer, null: true
      add :min_energy, :integer, null: true
      add :max_energy, :integer, null: true
      add :state_id, references(:states), null: true
    end
  end
end
