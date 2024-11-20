defmodule GEMS.Engine.Schema.TraitElementRate do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:element_id]
  @optional_fields [:modifier]

  schema "traits_element_rates" do
    field :modifier, :float
    belongs_to :element, GEMS.Engine.Schema.Element
  end

  def changeset(element_rate, attrs) do
    element_rate
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:modifier, greater_than_or_equal_to: 0.0)
    |> assoc_constraint(:element)
  end
end
