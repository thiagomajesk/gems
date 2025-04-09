defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Log
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Combat
  alias GEMS.Engine.Battler.Effect
  alias GEMS.Engine.Battler.Snapshot
  alias GEMS.Database.Effects.HealthRegen
  alias GEMS.Database.Effects.HealthDrain
  alias GEMS.Database.Effects.ApplyCondition
  alias GEMS.Database.Effects.StatChange
  alias GEMS.Database.Effects.DamageFlat
  alias GEMS.Database.Effects.DamageRate

  @primary_key false
  embedded_schema do
    field :timestamp, :utc_datetime_usec
    field :logs, {:array, :map}, default: []
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

  @doc false
  def apply_effect(event, nil), do: event

  def apply_effect(event, %DamageFlat{} = effect) do
    %{damage_max: max, damage_min: min} = effect

    damage = :rand.uniform(max - min + 1) + min - 1
    log = Log.damage(:target, damage)

    event
    |> Map.update!(:logs, &[log | &1])
    |> Map.update!(:target, &Actor.change_health(&1, -damage))
  end

  def apply_effect(event, %DamageRate{} = effect) do
    damage = round(event.caster.damage * effect.percentage)
    log = Log.damage(:target, damage)

    event
    |> Map.update!(:logs, &[log | &1])
    |> Map.update!(:target, &Actor.change_health(&1, -damage))
  end

  def apply_effect(event, %HealthRegen{} = effect) do
    log = Log.regen(:target, effect.amount)

    event
    |> Map.update!(:logs, &[log | &1])
    |> Map.update!(:target, &Actor.change_health(&1, effect.amount))
  end

  def apply_effect(event, %HealthDrain{} = effect) do
    %{amount: amount} = effect
    caster_log = Log.regen(:caster, health: amount)
    target_log = Log.drain(:target, health: -amount)

    event
    |> Map.update!(:logs, &[caster_log | &1])
    |> Map.update!(:logs, &[target_log | &1])
    |> Map.update!(:caster, &Actor.change_health(&1, amount))
    |> Map.update!(:target, &Actor.change_health(&1, -amount))
  end

  def apply_effect(event, %ApplyCondition{} = effect) do
    %{condition: condition, duration: duration} = effect
    log = Log.condition(:caster, condition, duration)

    event
    |> Map.update!(:logs, &[log | &1])
    |> Map.update!(:target, &Actor.apply_condition(&1, condition, 1))
  end

  def apply_effect(event, %StatChange{} = effect) do
    %{stat: stat, value: value, duration: duration, assessment: assessment} = effect
    log = Log.change(:caster, assessment, stat, value, duration)

    event
    |> Map.update!(:logs, &[log | &1])
  end

  def apply_effect(other_effect, _event),
    do: raise("Unknown effect type: #{inspect(other_effect)}")
end
