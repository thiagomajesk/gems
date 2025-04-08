defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__

  @parties GEMS.Engine.Constants.parties()

  embedded_schema do
    field :name, :string
    field :party, Ecto.Enum, values: @parties

    field :health, :integer
    field :energy, :integer
    field :aggro, :integer, default: 0
    field :charge, :integer, default: 0

    field :damage, :integer
    field :accuracy, :float
    field :evasion, :float
    field :fortitude, :float
    field :recovery, :float
    field :maximum_health, :integer
    field :maximum_energy, :integer
    field :physical_armor, :integer
    field :magical_armor, :integer
    field :attack_speed, :integer
    field :critical_chance, :float
    field :critical_multiplier, :float
    field :damage_penetration, :integer
    field :damage_reflection, :integer
    field :health_regeneration, :float
    field :energy_regeneration, :float
    field :fire_resistance, :float
    field :water_resistance, :float
    field :earth_resistance, :float
    field :air_resistance, :float

    field :burning_charges, :integer, default: 0
    field :poisoned_charges, :integer, default: 0
    field :frozen_charges, :integer, default: 0
    field :shocked_charges, :integer, default: 0
    field :bleeding_charges, :integer, default: 0
    field :stunned_charges, :integer, default: 0
    field :marked_charges, :integer, default: 0
    field :blighted_charges, :integer, default: 0
    field :silenced_charges, :integer, default: 0

    field :action_patterns, {:array, :map}, default: [], virtual: true
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2

  def change_health(%Actor{} = actor, amount) do
    Map.update!(actor, :health, fn health ->
      max(0, min(maximum_health(actor), health + amount))
    end)
  end

  def change_energy(%Actor{} = actor, amount) do
    Map.update!(actor, :energy, fn energy ->
      max(0, min(maximum_energy(actor), energy + amount))
    end)
  end

  # TODO: Get max health including possible buffs
  def maximum_health(%Actor{maximum_health: max}), do: max

  # TODO: Get max energy including possible buffs
  def maximum_energy(%Actor{maximum_energy: max}), do: max

  def apply_condition(%Actor{} = actor, condition, value) do
    field = String.to_existing_atom("#{condition}_charges")

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
end
