defmodule GEMS.Repo.Migrations.CreateItemsTables do
  use Ecto.Migration

  def change do
    ################################################################################
    # Items
    ################################################################################

    create table(:items) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :icon, :string, null: true
      add :type_id, references(:item_types), null: false
      add :tier, :integer, null: false, default: 0
      add :price, :integer, null: true
      add :gatherable, :boolean, null: false, default: false
      add :craftable, :boolean, null: false, default: false
      add :farmable, :boolean, null: false, default: false
      add :consumable, :boolean, null: false, default: false

      add :scope_option_id, references(:scope_options), null: true
      add :activation_option_id, references(:activation_options), null: false
      add :damage_option_id, references(:damage_options), null: true
    end

    create unique_index(:items, :name)

    create constraint(:items, :check_item_single_purpose,
             check: "(gatherable::int + craftable::int + farmable::int + consumable::int) = 1"
           )

    ################################################################################
    # Items Effects
    ################################################################################

    create table(:items_effects, primary_key: false) do
      add :item_id, references(:items), null: false, primary_key: true
      add :effect_id, references(:effects), null: false, primary_key: true
    end

    ################################################################################
    # Items Ingredients
    ################################################################################

    create table(:items_ingredients, primary_key: false) do
      add :item_id, references(:items), null: false, primary_key: true
      add :ingredient_id, references(:items), null: false, primary_key: true
    end
  end
end
