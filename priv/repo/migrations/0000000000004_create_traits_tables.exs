defmodule GEMS.Repo.Migrations.CreateTraitsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Traits
    ################################################################################

    create table(:traits) do
      add :kind, :string, null: false
      add :state_id, references(:states, on_delete: :delete_all)
      add :class_id, references(:classes, on_delete: :delete_all)
      add :creature_id, references(:creatures, on_delete: :delete_all)
      add :equipment_id, references(:equipments, on_delete: :delete_all)
    end

    create constraint(:traits, :single_association,
             check: "num_nonnulls(state_id, class_id, creature_id, equipment_id) = 1"
           )

    ################################################################################
    # Element Rates
    ################################################################################

    create table(:traits_element_rates) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :element_id, references(:elements, on_delete: :delete_all), null: false
      add :rate, :float, null: false, default: 0
    end

    create constraint(:traits_element_rates, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'element_rate')"
           )

    ################################################################################
    # Parameter Rates
    ################################################################################

    create table(:traits_parameter_rates) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :parameter, :string, null: false
      add :type, :string, null: false
      add :rate, :float, null: false, default: 0
    end

    create constraint(:traits_parameter_rates, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'parameter_rate')"
           )

    ################################################################################
    # State Rates
    ################################################################################

    create table(:traits_state_rates) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :state_id, references(:states, on_delete: :delete_all), null: false
      add :rate, :float, null: false, default: 0
    end

    create constraint(:traits_state_rates, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'state_rate')"
           )

    ################################################################################
    # Param Bonus
    ################################################################################

    create table(:traits_parameter_change) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :parameter, :string, null: false
      add :flat, :integer, null: false, default: 0
      add :rate, :float, null: false, default: 0
    end

    create constraint(:traits_parameter_change, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'parameter_change')"
           )

    ################################################################################
    # Attack Elements
    ################################################################################

    create table(:traits_attack_elements) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :element_id, references(:elements, on_delete: :delete_all), null: false
    end

    create constraint(:traits_attack_elements, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'attack_element')"
           )

    ################################################################################
    # Attack States
    ################################################################################

    create table(:traits_attack_states) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :state_id, references(:states, on_delete: :delete_all), null: false
      add :rate, :float, null: false, default: 0
    end

    create constraint(:traits_attack_states, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'attack_state')"
           )

    ################################################################################
    # Attack Skills
    ################################################################################

    create table(:traits_attack_skills) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :skill_id, references(:skills, on_delete: :delete_all), null: false
    end

    create constraint(:traits_attack_skills, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'attack_skill')"
           )

    ################################################################################
    # Skills Seals
    ################################################################################

    create table(:traits_skills_seals) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :skill_id, references(:skills, on_delete: :delete_all), null: false
    end

    create constraint(:traits_skills_seals, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'skill_seal')"
           )

    ################################################################################
    # Item Seals
    ################################################################################

    create table(:traits_item_seals) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false
    end

    create constraint(:traits_item_seals, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'item_seal')"
           )

    ################################################################################
    # Equipment Seals
    ################################################################################

    create table(:traits_equipment_seals) do
      add :trait_id, references(:traits, on_delete: :delete_all), null: false
      add :equipment_id, references(:equipments, on_delete: :delete_all), null: false
    end

    create constraint(:traits_equipment_seals, :trait_kind_matches,
             check: "check_column_value(trait_id, 'traits', 'kind', 'equipment_seal')"
           )
  end
end
