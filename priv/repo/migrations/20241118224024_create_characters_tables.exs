defmodule GEMS.Repo.Migrations.CreateCharactersTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Characters
    ################################################################################

    create table(:characters) do
      add :name, :string, null: false
      add :title, :string, null: true

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

      add :faction_id, references(:factions), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:characters, :name)

    ################################################################################
    # Characters Professions
    ################################################################################

    create table(:characters_professions, primary_key: false) do
      add :character_id, references(:characters), null: false, primary_key: true
      add :vocation_id, references(:professions), null: false, primary_key: true
      add :level, :integer, default: 0
      add :exp, :integer, default: 0
    end
  end
end
