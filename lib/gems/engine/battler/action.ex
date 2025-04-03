defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Event

  @affinities GEMS.Engine.Constants.elements()
  @effect_types_mappings GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities

    field :caster_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    field :target_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    embeds_one :caster, GEMS.Engine.Battler.Actor
    embeds_many :targets, GEMS.Engine.Battler.Actor
  end

  def events_for_caster(%Action{} = action) do
    Enum.map(action.caster_effects, fn effect ->
      Event.new(:caster, action.caster, effect)
    end)
  end

  def events_for_target(%Action{} = action) do
    Enum.flat_map(action.targets, fn target ->
      Enum.map(action.target_effects, fn effect ->
        Event.new(:target, target, effect)
      end)
    end)
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
