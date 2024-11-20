defmodule GEMS.Engine.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :tier, :integer, default: 0
    field :price, :integer
    field :stackable, :boolean, default: false
    field :hidden, :boolean, default: false
    field :sellable, :boolean, default: false

    belongs_to :type, GEMS.Engine.Schema.ItemType
    belongs_to :scope_option, GEMS.Engine.Schema.ScopeOption
    belongs_to :activation_option, GEMS.Engine.Schema.ActivationOption
    belongs_to :damage_option, GEMS.Engine.Schema.DamageOption
    many_to_many :effects, GEMS.Engine.Schema.Effect, join_through: "items_effects"
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :name,
      :description,
      :icon,
      :tier,
      :price,
      :stackable,
      :hidden,
      :sellable,
      :type_id,
      :scope_option_id,
      :activation_option_id,
      :damage_option_id
    ])
    |> validate_required([:name, :type_id, :activation_option_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:type)
    |> assoc_constraint(:scope_option)
    |> assoc_constraint(:activation_option)
    |> assoc_constraint(:damage_option)
  end
end
