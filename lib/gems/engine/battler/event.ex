defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  embedded_schema do
    # Effects Snapshot
    field :effects, {:array, :map}, default: []

    embeds_one :target, Actor
  end

  def commit_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event.target, fn effect, target ->
      Actor.commit_effect(target, effect)
    end)
  end

  def revert_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event.target, fn effect, target ->
      Actor.revert_effect(target, effect)
    end)
  end
end
