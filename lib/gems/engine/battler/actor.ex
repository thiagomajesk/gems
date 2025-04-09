defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__

  @action_points_limit 10

  @parties GEMS.Engine.Constants.parties()

  embedded_schema do
    field :name, :string
    field :party, Ecto.Enum, values: @parties
    field :aggro, :integer, default: 0
    field :charge, :integer, default: 0
    field :action_points, :integer, default: @action_points_limit
    field :maximum_action_points, :integer, default: @action_points_limit

    field :health, :integer
    field :physical_armor, :integer
    field :magical_armor, :integer

    field :maximum_health, :integer
    field :maximum_physical_armor, :integer
    field :maximum_magical_armor, :integer

    field :damage, :integer
    field :accuracy, :float
    field :evasion, :float
    field :fortitude, :float
    field :recovery, :float
    field :attack_speed, :integer
    field :critical_chance, :float
    field :critical_multiplier, :float
    field :damage_penetration, :integer
    field :damage_reflection, :integer
    field :health_regeneration, :float
    field :fire_resistance, :float
    field :water_resistance, :float
    field :earth_resistance, :float
    field :air_resistance, :float

    field :burning_tokens, :integer, default: 0
    field :poisoned_tokens, :integer, default: 0
    field :frozen_tokens, :integer, default: 0
    field :shocked_tokens, :integer, default: 0
    field :bleeding_tokens, :integer, default: 0
    field :stunned_tokens, :integer, default: 0
    field :marked_tokens, :integer, default: 0
    field :blighted_tokens, :integer, default: 0
    field :silenced_tokens, :integer, default: 0
    field :fortified_tokens, :integer, default: 0
    field :vulnerable_tokens, :integer, default: 0

    field :action_patterns, {:array, :map}, default: [], virtual: true
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2

  def upkeep(%Actor{} = actor) do
    actor
    |> tick_buffs()
    |> tick_debuffs()
    |> change_aggro(-1)
    |> tick_conditions()
    |> change_action_points(1)
  end

  def change_aggro(%Actor{} = actor, amount) do
    Map.update!(actor, :aggro, fn aggro ->
      max(0, min(100, aggro + amount))
    end)
  end

  def change_health(%Actor{} = actor, amount) do
    Map.update!(actor, :health, fn health ->
      max(0, min(maximum_health(actor), health + amount))
    end)
  end

  def change_action_points(%Actor{} = actor, amount) do
    Map.update!(actor, :action_points, fn action_points ->
      max(0, min(10, action_points + amount))
    end)
  end

  # TODO: Get max health including possible buffs
  def maximum_health(%Actor{maximum_health: max}), do: max

  def apply_condition(%Actor{} = actor, condition, value) do
    field = String.to_existing_atom("#{condition}_tokens")

    Map.update!(actor, field, fn charges ->
      max(0, min(maximum_health(actor), charges + value))
    end)
  end

  @doc """
  Replaces the actors in the list with the updated actors.
  Takes the list (or lookup table) of actors to be replaced.
  """
  def replace_with([], _updates), do: []
  def replace_with(actors, []), do: actors
  def replace_with(actors, updates) when updates == %{}, do: actors

  def replace_with(actors, updates) when is_list(updates) do
    replace_with(actors, Map.new(updates, &{&1.id, &1}))
  end

  def replace_with([actor | others], updates) when is_map(updates) do
    case Map.pop(updates, actor.id) do
      {nil, updates} -> [actor | replace_with(others, updates)]
      {updated, updates} -> [updated | replace_with(others, updates)]
    end
  end

  def tick_buffs(actor), do: actor
  def tick_debuffs(actor), do: actor

  def tick_conditions(actor) do
    actor
    |> Map.update!(:burning_tokens, &max(0, &1 - 1))
    |> Map.update!(:poisoned_tokens, &max(0, &1 - 1))
    |> Map.update!(:frozen_tokens, &max(0, &1 - 1))
    |> Map.update!(:shocked_tokens, &max(0, &1 - 1))
    |> Map.update!(:bleeding_tokens, &max(0, &1 - 1))
    |> Map.update!(:stunned_tokens, &max(0, &1 - 1))
    |> Map.update!(:marked_tokens, &max(0, &1 - 1))
    |> Map.update!(:blighted_tokens, &max(0, &1 - 1))
    |> Map.update!(:silenced_tokens, &max(0, &1 - 1))
    |> Map.update!(:fortified_tokens, &max(0, &1 - 1))
    |> Map.update!(:vulnerable_tokens, &max(0, &1 - 1))
    |> Map.update!(:action_points, &max(0, &1 - 1))
  end
end
