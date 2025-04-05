defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Effect

  @primary_key false
  embedded_schema do
    field :timestamp, :utc_datetime_usec

    embeds_one :caster, GEMS.Engine.Battler.Actor
    embeds_one :target, GEMS.Engine.Battler.Actor

    embeds_many :effects, GEMS.Engine.Battler.Effect
  end

  def new(caster, target, effects) do
    %Event{
      caster: caster,
      target: target,
      effects: effects,
      timestamp: DateTime.utc_now()
    }
  end

  def apply_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.filter(&(&1.chance >= :rand.uniform()))
    |> Enum.reduce(event, fn effect, event ->
      # TODO: Handle the different effects (on_hit, on_miss, on_crit)
      case Effect.apply_effect(effect.on_hit, event.caster, event.target) do
        target when is_struct(target) -> %{event | target: target}
        {caster, target} -> %{event | caster: caster, target: target}
      end
    end)
  end
end
