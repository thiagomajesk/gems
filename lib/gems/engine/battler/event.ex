defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor

  embedded_schema do
    field :description, :string

    field :effects, {:array, GEMS.Database.Dynamic},
      types: GEMS.Engine.Constants.effect_types_mappings(),
      default: []

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
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
