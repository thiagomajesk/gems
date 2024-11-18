defmodule GEMS.Engine.Schema.TraitStateRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "traits_state_rates" do
    field :chance, :float, default: 1.0
    belongs_to :state, GEMS.Engine.Schema.State
  end

  @doc false
  def changeset(state_rate, attrs) do
    state_rate
    |> cast(attrs, [:state_id, :chance])
    |> validate_required([:state_id])
    |> validate_number(:chance, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> assoc_constraint(:state)
  end
end
