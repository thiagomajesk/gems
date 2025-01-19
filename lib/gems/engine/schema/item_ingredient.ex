defmodule GEMS.Engine.Schema.ItemIngredient do
  use GEMS.Database.Schema, preset: :default

  # Item fk ommited so we can cast the assoc from item
  @required_fields [:amount, :ingredient_id]

  @primary_key false
  schema "items_ingredients" do
    field :amount, :integer

    belongs_to :item, GEMS.Engine.Schema.Item, primary_key: true
    belongs_to :ingredient, GEMS.Engine.Schema.Item, primary_key: true
  end

  @doc false
  def changeset(item_ingredient, attrs) do
    item_ingredient
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:ingredient_id)
    |> unique_constraint([:item_id, :ingredient_id], name: :items_ingredients_pkey)
  end
end
