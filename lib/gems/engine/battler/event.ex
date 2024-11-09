defmodule GEMS.Engine.Battler.Event do
  alias __MODULE__
  alias GEMS.Engine.Battler.Effect

  @derive {Inspect, only: [:effects, :timestamp]}
  defstruct [:source, :target, :effects, :timestamp]

  def new(source, target, effects) do
    %Event{
      source: source,
      target: target,
      effects: effects,
      timestamp: DateTime.utc_now()
    }
  end

  def commit_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event.target, fn effect, target ->
      Effect.commit_effect(target, effect)
    end)
  end

  def revert_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event.target, fn effect, target ->
      Effect.revert_effect(target, effect)
    end)
  end
end
