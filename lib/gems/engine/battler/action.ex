defmodule GEMS.Engine.Battler.Action do
  use Ecto.Schema

  alias __MODULE__

  # alias GEMS.Engine.Battler.Event

  @affinities GEMS.Engine.Constants.elements()
  @target_scopes GEMS.Engine.Constants.target_scopes()

  embedded_schema do
    field :name, :string
    field :health_cost, :integer
    field :energy_cost, :integer
    field :affinity, Ecto.Enum, values: @affinities
    field :target_scope, Ecto.Enum, values: @target_scopes
    field :target_number, :integer, default: 1
    field :random_targets, :integer, default: 0

    field :effects, {:array, GEMS.Database.Dynamic},
      types: GEMS.Engine.Constants.effect_types_mappings(),
      default: []
  end

  def pick_targets(%Action{} = action, actors) do
    sorted_actors = Enum.sort_by(actors, & &1.aggro, :desc)
    targets = Enum.take(sorted_actors, action.target_number)

    remaining_actors = actors -- targets
    random_targets = Enum.take_random(remaining_actors, action.random_targets)

    Enum.concat(targets, random_targets)
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
