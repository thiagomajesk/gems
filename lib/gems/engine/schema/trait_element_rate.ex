defmodule GEMS.Engine.Schema.TraitElementRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "traits_element_rates" do
    field :modifier, :float, default: 1.0
    belongs_to :element, GEMS.Engine.Schema.Element
  end

  @doc false
  def changeset(element_rate, attrs) do
    element_rate
    |> cast(attrs, [:element_id, :modifier])
    |> validate_required([:element_id])
    |> validate_number(:modifier, greater_than_or_equal_to: 0.0)
    |> assoc_constraint(:element)
  end
end
