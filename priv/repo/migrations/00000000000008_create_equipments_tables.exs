defmodule GEMS.Repo.Migrations.CreateEquipmentsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Equipments
    ################################################################################

    create table(:equipments) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :type_id, references(:equipment_types), null: false
      add :slot, :string, null: false
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
      add :max_energy, :integer, default: 0
      add :energy_regen, :integer, default: 0
      add :magic_damage, :integer, default: 0
      add :ability_power, :integer, default: 0
    end

    create unique_index(:equipments, :code)

    ################################################################################
    # Equipments Abilities
    ################################################################################

    create table(:equipments_abilities, primary_key: false) do
      add :equipment_id, references(:equipments), null: false, primary_key: true
      add :ability_id, references(:abilities), null: false, primary_key: true
    end

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
