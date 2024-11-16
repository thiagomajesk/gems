defmodule GEMS.Repo.Migrations.CreateTraitsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Parameter Rates
    ################################################################################

    create table(:traits_parameter_rates) do
      add :parameter, :string, null: false
      add :modifier, :float, default: 1.0
    end

    ################################################################################
    # Element Rates
    ################################################################################

    create table(:traits_element_rates) do
      add :element_id, references(:elements), null: false
      add :modifier, :float, default: 1.0
    end

    ################################################################################
    # State Rates
    ################################################################################

    create table(:traits_state_rates) do
      add :state_id, references(:states), null: false
      add :chance, :float, default: 1.0
    end

    ################################################################################
    # Traits
    ################################################################################

    create table(:traits) do
      add :parameter_rate_id, references(:traits_parameter_rates)
      add :element_rate_id, references(:traits_element_rates)
      add :state_rate_id, references(:traits_state_rates)
    end
  end
end
