defmodule GEMS.Repo.Migrations.CreateCreaturesTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Creatures
    ################################################################################

    create table(:creatures) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :image, :string, null: true
      add :type_id, references(:creature_types), null: false
      add :biome_id, references(:biomes), null: false

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
      add :max_energy, :integer, default: 0
      add :energy_regen, :integer, default: 0
      add :magic_damage, :integer, default: 0
      add :ability_power, :integer, default: 0
    end

    create unique_index(:creatures, :code)

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
