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

  schema "damage_options" do
    field :damage_type, Ecto.Enum, values: @damage_types
    field :formula, :string
    field :variance, :float, default: 0.0
    field :critical_hits, :boolean, default: false
    belongs_to :element, GEMS.Engine.Schema.Element
  end

  @doc false
  def changeset(damage_option, attrs) do
    damage_option
    |> cast(attrs, [:damage_type, :element_id, :formula, :variance, :critical_hits])
    |> validate_required([:damage_type, :element_id])
    |> validate_number(:variance, greater_than_or_equal_to: 0.0)
    |> assoc_constraint(:element)
  end
end
