defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    embeds_one :skill, GEMS.Engine.Battler.Skill
    embeds_one :caster, GEMS.Engine.Battler.Actor
    embeds_many :targets, GEMS.Engine.Battler.Actor
  end

  # def events_for(%Action{type: :skill} = action) do
  #   Enum.map(action.targets, fn target ->
  #     %Event{
  #       target: target,
  #       effects: action.skill.effects
  #     }
  #   end)
  # end

  # def events_for(%Action{type: :item} = action) do
  #   Enum.map(action.targets, fn target ->
  #     %Event{
  #       target: target,
  #       effects: action.item.effects
  #     }
  #   end)
  # end
end
