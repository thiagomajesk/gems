defmodule GEMS.Engine.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @purposes [
    :to_gather,
    :to_craft,
    :to_farm,
    :to_consume
  ]

  @required_fields [:name, :type_id, :purpose, :activation_option_id]
  @optional_fields [:description, :icon, :tier, :price]

  schema "items" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :tier, :integer
    field :price, :integer
    field :purpose, Ecto.Enum, values: @purposes

    belongs_to :type, GEMS.Engine.Schema.ItemType
    belongs_to :scope_option, GEMS.Engine.Schema.ScopeOption
    belongs_to :activation_option, GEMS.Engine.Schema.ActivationOption
    belongs_to :damage_option, GEMS.Engine.Schema.DamageOption
    many_to_many :effects, GEMS.Engine.Schema.Effect, join_through: "items_effects"
    many_to_many :ingredients, GEMS.Engine.Schema.Item, join_through: "items_ingredients"
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> assoc_constraint(:type)
    |> assoc_constraint(:scope_option)
    |> assoc_constraint(:activation_option)
    |> assoc_constraint(:damage_option)
  end
end
