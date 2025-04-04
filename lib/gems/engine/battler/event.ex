defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Effect

  @effect_types_mapping GEMS.Engine.Constants.effect_types_mappings()

  @primary_key false
  embedded_schema do
    field :timestamp, :utc_datetime_usec

    field :effects, {:array, GEMS.Database.Dynamic}, types: @effect_types_mapping

    embeds_one :source, GEMS.Engine.Battler.Actor
    embeds_one :target, GEMS.Engine.Battler.Actor
  end

  def new(source, target, effects) do
    %Event{
      source: source,
      target: target,
      effects: effects,
      timestamp: DateTime.utc_now()
    }
  end

  def apply_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event, fn effect, event ->
      case Effect.apply_effect(effect, event.source, event.target) do
        target when is_struct(target) -> %{event | target: target}
        {source, target} -> %{event | source: source, target: target}
      end
    end)
  end
end
