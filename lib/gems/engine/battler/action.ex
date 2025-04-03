defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Event

  @affinities GEMS.Engine.Constants.elements()
  @effect_types_mappings GEMS.Engine.Constants.effect_types_mappings()

  embedded_schema do
    field :name, :string
    field :affinity, Ecto.Enum, values: @affinities
    field :health_cost, :integer
    field :energy_cost, :integer

    field :caster_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    field :target_effects, {:array, GEMS.Database.Dynamic},
      types: @effect_types_mappings,
      default: []

    embeds_one :caster, GEMS.Engine.Battler.Actor
    embeds_many :targets, GEMS.Engine.Battler.Actor
  end

  def events_for(%Action{} = action) do
    caster_events = events_for_caster(action)
    target_events = events_for_target(action)
    Enum.concat(caster_events, target_events)
  end

  # defp events_for_action(action) do
  #   # GEMS.Database.Effects.ActionCost
  #   effects = []
  #   map_events(:action, effects, [action.caster])
  # end

  defp events_for_caster(action) do
    effects = filter_effects(action.caster_effects)
    map_events(:caster, effects, [action.caster])
  end

  defp events_for_target(action) do
    effects = filter_effects(action.target_effects)
    map_events(:target, effects, action.targets)
  end

  defp filter_effects(effects) do
    Enum.filter(effects, fn
      %{chance: chance} -> chance >= :rand.uniform()
      _event -> true
    end)
  end

  defp map_events(origin, effects, targets) do
    Enum.flat_map(targets, fn target ->
      Enum.map(effects, fn effect ->
        Event.new(origin, target, effect)
      end)
    end)
  end
end
