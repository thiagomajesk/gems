defmodule GEMS.Engine.Schema.TraitStateRate do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:state_id]
  @optional_fields [:chance]

  schema "traits_state_rates" do
    field :chance, :float
    belongs_to :state, GEMS.Engine.Schema.State
  end

  def changeset(state_rate, attrs) do
    state_rate
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:chance, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> assoc_constraint(:state)
  end
end
