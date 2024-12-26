defmodule GEMS.Engine.Schema.ItemIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:amount, :item_id, :ingredient_id]

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
  end
end
