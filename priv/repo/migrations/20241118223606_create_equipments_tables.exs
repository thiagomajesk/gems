defmodule GEMS.Repo.Migrations.CreateEquipmentsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Equipments
    ################################################################################

    create table(:equipments) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :type_id, references(:equipment_types), null: false
      add :slot, :string, null: false
      add :tier, :integer, null: false, default: 0
      add :price, :integer, null: true
      add :hidden, :boolean, null: false, default: false
      add :sellable, :boolean, null: false, default: false

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

    ################################################################################
    # Equipments Traits
    ################################################################################

    create table(:equipments_traits, primary_key: false) do
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :trait_id, references(:traits), null: false, primary_key: true
    end

    ################################################################################
    # Equipments Abilities
    ################################################################################

    create table(:equipments_abilities, primary_key: false) do
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :ability_id, references(:abilities), null: false, primary_key: true
    end
  end
end
