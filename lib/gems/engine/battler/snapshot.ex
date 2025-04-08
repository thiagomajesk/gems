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
    field :health, :integer
    field :energy, :integer
    field :aggro, :integer
    field :charge, :integer
  end

  def new(%Actor{} = actor) do
    %Snapshot{
      id: actor.id,
      name: actor.name,
      health: actor.health,
      energy: actor.energy,
      charge: actor.charge,
      aggro: actor.aggro
    }
  end
end
