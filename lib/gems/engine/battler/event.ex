defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  @effect_types_mapping GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :description, :string

    field :effect, GEMS.Database.Dynamic, types: @effect_types_mapping

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    embeds_many :target, GEMS.Engine.Battler.Actor
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
end
