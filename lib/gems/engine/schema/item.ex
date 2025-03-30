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
      :price,
      :target_side,
      :target_filter,
      :target_number,
      :random_targets,
      :hit_type,
      :success_rate,
      :repeats
    ],
    default_preloads: [
      :item_ingredients
    ]

  @tiers GEMS.Engine.Constants.tiers()

  @hit_types GEMS.Engine.Constants.hit_types()
  @target_sides GEMS.Engine.Constants.target_sides()

  schema "items" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer

    field :repeats, :integer
    field :target_side, Ecto.Enum, values: @target_sides
    field :target_filter, Ecto.Enum, values: [:alive, :dead]
    field :target_number, :integer
    field :random_targets, :integer
    field :success_rate, :float

    field :hit_type, Ecto.Enum, values: @hit_types

    field :effects, {:array, :map}, default: []

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
