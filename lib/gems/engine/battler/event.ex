defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__

  @effect_types_mapping GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :origin, Ecto.Enum, values: [:caster, :target]
    field :description, :string
    field :timestamp, :utc_datetime_usec

    field :effect, GEMS.Database.Dynamic, types: @effect_types_mapping

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    embeds_many :target, GEMS.Engine.Battler.Actor
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

  # def commit_effects(%Event{} = event) do
  #   event.effects
  #   |> Enum.reverse()
  #   |> Enum.reduce(event.target, fn effect, target ->
  #     Actor.commit_effect(target, effect)
  #   end)
  # end

  # def revert_effects(%Event{} = event) do
  #   event.effects
  #   |> Enum.reverse()
  #   |> Enum.reduce(event.target, fn effect, target ->
  #     Actor.revert_effect(target, effect)
  #   end)
  # end

  defp get_icon(_effect), do: nil
  defp describe(_effect), do: nil
end
