defmodule GEMS.Repo.Migrations.CreateItemsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Items
    ################################################################################

    create table(:items) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :description, :string, null: true
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
  end
end
