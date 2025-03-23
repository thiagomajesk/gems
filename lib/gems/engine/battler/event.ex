defmodule GEMS.Engine.Battler.Event do
  use Ecto.Schema

  alias __MODULE__

  @sources [:skill, :item]

  embedded_schema do
    field :source, Ecto.Enum, values: @sources

    # Effects Snapshot
    field :effects, {:array, :map}, default: []

    field :item, :map
    field :skill, :map

    embeds_one :target, GEMS.Engine.Schema.Actor
  end

  def apply_effect(%Event{} = event) do
    event.effects
    |> Enum.reverse()
    |> Enum.reduce(event.target, fn
      %{source: :skill} = effect, target ->
        commit_skill_effect(effect.skill, target)

      %{source: :item} = effect, target ->
        commit_item_effect(effect.item, target)
    end)
  end

  # TODO: Return the updated actor (target)
  defp commit_skill_effect(_skill, target), do: target

  # TODO: Return the updated actor (target)
  defp commit_item_effect(_item, target), do: target
end
