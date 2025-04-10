defmodule GEMS.Engine.Battler.Snapshot do
  @moduledoc """
  A bare minimum representation of an actor's current state.
  This is used by the engine exclusively for rendering effect changes.
  """
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  embedded_schema do
    field :name, :string
    field :aggro, :integer
    field :charge, :integer
    field :health, :integer
    field :action_points, :integer
  end

  def new(%Actor{} = actor) do
    %Snapshot{
      id: actor.id,
      name: actor.name,
      aggro: actor.aggro,
      charge: actor.charge,
      health: actor.health,
      action_points: actor.action_points
    }
  end
end
