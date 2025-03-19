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
      :target_status,
      :target_number,
      :random_targets,
      :hit_type,
      :success_rate,
      :repeats,
      :damage_type,
      :damage_formula,
      :damage_variance,
      :critical_hits,
      :messages,
      :damage_element_id
    ],
    default_preloads: [
      :item_ingredients,
      effects: [
        :recovery,
        :state_change,
        :parameter_change
      ]
    ]

  @tiers GEMS.Engine.Constants.tiers()

  @hit_types GEMS.Engine.Constants.hit_types()
  @target_sides GEMS.Engine.Constants.target_sides()
  @damage_types GEMS.Engine.Constants.damage_types()

  schema "items" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer
    field :messages, :map

    field :target_side, Ecto.Enum, values: @target_sides
    field :target_status, Ecto.Enum, values: [:alive, :dead]
    field :target_number, :integer
    field :random_targets, :integer

    field :hit_type, Ecto.Enum, values: @hit_types
    field :success_rate, :float
    field :repeats, :integer

    field :damage_type, Ecto.Enum, values: @damage_types
    field :damage_formula, :string
    field :damage_variance, :float
    field :critical_hits, :boolean

    belongs_to :type, GEMS.Engine.Schema.ItemType
    belongs_to :damage_element, GEMS.Engine.Schema.Element

    has_many :effects, GEMS.Engine.Schema.Effect, on_replace: :delete
    has_many :item_ingredients, GEMS.Engine.Schema.ItemIngredient, on_replace: :delete

    many_to_many :ingredients, GEMS.Engine.Schema.Item, join_through: "items_ingredients"
  end

  def build_changeset(item, attrs, opts) do
    changeset = super(item, attrs, opts)

    changeset
    |> cast_assoc(:effects, sort_param: :effects_sort, drop_param: :effects_drop)
    |> cast_assoc(:item_ingredients,
      sort_param: :item_ingredients_sort,
      drop_param: :item_ingredients_drop
    )
    |> unique_constraint(:name)
    |> unique_constraint(:code)
    |> foreign_key_constraint(:type_id)
  end
end
