defmodule GEMS.Engine.Schema.CreatureActionPattern do
  use Ecto.Schema
  import Ecto.Changeset

  schema "creature_action_patterns" do
    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :action_pattern, GEMS.Engine.Schema.ActionPattern
  end

  @doc false
  def changeset(creature_action_pattern, attrs) do
    creature_action_pattern
    |> cast(attrs, [:creature_id, :action_pattern_id])
    |> validate_required([:creature_id, :action_pattern_id])
    |> assoc_constraint(:creature)
    |> assoc_constraint(:action_pattern)
  end
end
