defmodule GEMS.Engine.Schema.CreatureTrait do
  use Ecto.Schema
  import Ecto.Changeset

  schema "creatures_traits" do
    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  @doc false
  def changeset(creature_trait, attrs) do
    creature_trait
    |> cast(attrs, [:creature_id, :trait_id])
    |> validate_required([:creature_id, :trait_id])
    |> assoc_constraint(:creature)
    |> assoc_constraint(:trait)
  end
end
