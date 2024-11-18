defmodule GEMS.Engine.Schema.Trait do
  use Ecto.Schema
  import Ecto.Changeset

  schema "traits" do
    belongs_to :parameter_rate, GEMS.Engine.Schema.TraitParameterRate
    belongs_to :element_rate, GEMS.Engine.Schema.TraitElementRate
    belongs_to :state_rate, GEMS.Engine.Schema.TraitStateRate
  end

  @doc false
  def changeset(trait, attrs) do
    trait
    |> cast(attrs, [:parameter_rate_id, :element_rate_id, :state_rate_id])
    |> assoc_constraint(:parameter_rate)
    |> assoc_constraint(:element_rate)
    |> assoc_constraint(:state_rate)
  end
end
