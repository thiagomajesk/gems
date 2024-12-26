defmodule GEMS.Engine.Schema.Item do
  use GEMS.Database.Schema, :resource

  @required_fields [
    :name,
    :code,
    :type_id
  ]

  @optional_fields [
    :description,
    :icon,
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
  ]

  @target_sides [
    :self,
    :ally,
    :enemy,
    :ally_or_enemy
  ]

  @hit_types [
    :physical_attack,
    :magical_attack,
    :certain_hit
  ]

  @damage_types [
    :health_damage,
    :energy_damage,
    :health_recover,
    :energy_recover,
    :health_drain,
    :energy_drain
  ]

  schema "items" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
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
    has_many :item_ingredients, GEMS.Engine.Schema.ItemIngredient
    many_to_many :ingredients, GEMS.Engine.Schema.Item, join_through: "items_ingredients"
  end

  @doc false
  def changeset(item, attrs) do
    build_changeset(item, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(item, attrs) do
    build_changeset(
      item,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(item, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    item
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
