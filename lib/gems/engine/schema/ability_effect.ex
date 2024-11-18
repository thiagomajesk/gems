defmodule GEMS.Engine.Schema.AbilityEffect do
  use Ecto.Schema
  import Ecto.Changeset

  schema "abilities_effects" do
    belongs_to :ability, GEMS.Engine.Schema.Ability
    belongs_to :effect, GEMS.Engine.Schema.Effect
  end

  @doc false
  def changeset(ability_effect, attrs) do
    ability_effect
    |> cast(attrs, [:ability_id, :effect_id])
    |> validate_required([:ability_id, :effect_id])
    |> assoc_constraint(:ability)
    |> assoc_constraint(:effect)
  end
end
