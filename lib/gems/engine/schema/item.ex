defmodule GEMS.Engine.Schema.Item do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [
      :name,
      :code,
      :type_id,
      :tier
    ],
    optional_fields: [
      :description,
      :image,
      :price
    ],
    default_preloads: [
      :item_ingredients
    ]

  @tiers GEMS.Engine.Constants.tiers()

  schema "items" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer

    belongs_to :type, GEMS.Engine.Schema.ItemType

    has_many :item_ingredients, GEMS.Engine.Schema.ItemIngredient, on_replace: :delete

    many_to_many :ingredients, GEMS.Engine.Schema.Item,
      join_through: GEMS.Engine.Schema.ItemIngredient
  end

  def build_changeset(item, attrs, opts) do
    changeset = super(item, attrs, opts)

    changeset
    |> cast_assoc(:item_ingredients,
      sort_param: :item_ingredients_sort,
      drop_param: :item_ingredients_drop
    )
    |> unique_constraint(:name)
    |> unique_constraint(:code)
    |> foreign_key_constraint(:type_id)
  end
end
