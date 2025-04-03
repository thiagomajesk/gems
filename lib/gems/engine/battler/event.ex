defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Database.Effects.ActionCost

  @origins [:system, :action, :caster, :target]
  @effect_types_mapping GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :origin, Ecto.Enum, values: @origins
    field :description, :string
    field :timestamp, :utc_datetime_usec

    field :effect, GEMS.Database.Dynamic, types: @effect_types_mapping

    embeds_one :icon, GEMS.Database.GameIcon
    embeds_one :target, GEMS.Engine.Battler.Actor
  end

  def new(origin, target, effect) do
    %Event{
      origin: origin,
      target: target,
      effect: effect,
      icon: get_icon(effect),
      description: describe(effect),
      timestamp: DateTime.utc_now()
    }
  end

  def commit_effect(%Event{effect: %ActionCost{} = effect} = event) do
    event.target
    |> Map.update!(:health, &(&1 - effect.health_cost))
    |> Map.update!(:energy, &(&1 - effect.energy_cost))
  end

  def commit_effect(%Event{} = event), do: event.target

  defp get_icon(_effect), do: nil
  defp describe(_effect), do: nil
end
