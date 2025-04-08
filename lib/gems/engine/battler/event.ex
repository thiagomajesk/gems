defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Combat
  alias GEMS.Engine.Battler.Effect
  alias GEMS.Engine.Battler.Snapshot

  @primary_key false
  embedded_schema do
    field :timestamp, :utc_datetime_usec
    field :outcome, Ecto.Enum, values: [:miss, :dodge, :crit, :hit]

    embeds_one :caster, GEMS.Engine.Battler.Actor
    embeds_one :target, GEMS.Engine.Battler.Actor

    embeds_one :caster_snapshot, GEMS.Engine.Battler.Snapshot
    embeds_one :target_snapshot, GEMS.Engine.Battler.Snapshot

    embeds_many :effects, GEMS.Engine.Battler.Effect
  end

  def new(caster, target, effects) do
    outcome = Combat.outcome(caster, target)

    %Event{
      caster: caster,
      target: target,
      outcome: outcome,
      effects: effects,
      caster_snapshot: Snapshot.new(caster),
      target_snapshot: Snapshot.new(target),
      timestamp: DateTime.utc_now()
    }
  end

  def outcome_effects(%{outcome: outcome} = event) do
    event.effects
    |> Enum.map(&Effect.fetch_effect(&1, outcome))
    |> Enum.reject(&is_nil/1)
  end

  def apply_effects(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.filter(&(&1.chance >= :rand.uniform()))
    |> Enum.reduce(event, fn
      effect, %{outcome: :hit} = event ->
        apply_effect(event, effect.on_hit)

      effect, %{outcome: :crit} = event ->
        apply_effect(event, effect.on_crit)

      effect, %{outcome: :miss} = event ->
        apply_effect(event, effect.on_miss)

      effect, %{outcome: :dodge} = event ->
        apply_effect(event, effect.on_dodge)
    end)
  end

  defp apply_effect(event, nil), do: event

  defp apply_effect(event, effect) do
    case Effect.apply_effect(effect, event.caster, event.target) do
      target when is_struct(target) -> %{event | target: target}
      {caster, target} -> %{event | caster: caster, target: target}
    end
  end
end
