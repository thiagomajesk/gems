defmodule GEMS.Engine.Schema.DamageOption do
  use Ecto.Schema
  import Ecto.Changeset

  @damage_types [
    :health,
    :energy,
    :health_recover,
    :energy_recover,
    :health_drain,
    :energy_drain
  ]

  @required_fields [:damage_type, :element_id]
  @optional_fields [:formula, :variance, :critical_hits]

  schema "damage_options" do
    field :damage_type, Ecto.Enum, values: @damage_types
    field :formula, :string
    field :variance, :float
    field :critical_hits, :boolean

    belongs_to :element, GEMS.Engine.Schema.Element
  end

  @doc false
  def changeset(damage_option, attrs) do
    damage_option
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:variance, greater_than_or_equal_to: 0.0)
    |> assoc_constraint(:element)
  end
end
