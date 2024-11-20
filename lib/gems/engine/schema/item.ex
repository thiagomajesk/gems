defmodule GEMS.Engine.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :type_id, :activation_option_id]
  @optional_fields [:description, :icon, :tier, :price, :stackable, :hidden, :sellable]

  schema "items" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :tier, :integer
    field :price, :integer
    field :stackable, :boolean
    field :hidden, :boolean
    field :sellable, :boolean

    belongs_to :type, GEMS.Engine.Schema.ItemType
    belongs_to :scope_option, GEMS.Engine.Schema.ScopeOption
    belongs_to :activation_option, GEMS.Engine.Schema.ActivationOption
    belongs_to :damage_option, GEMS.Engine.Schema.DamageOption
    many_to_many :effects, GEMS.Engine.Schema.Effect, join_through: "items_effects"
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
