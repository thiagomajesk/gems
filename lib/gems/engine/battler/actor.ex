defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__

  @parties [:alpha, :bravo, :charlie, :delta]
  @states GEMS.Engine.Constants.states()

  embedded_schema do
    field :name, :string
    field :party, Ecto.Enum, values: @parties

    field :health, :integer, default: 0
    field :energy, :integer, default: 0
    field :aggro, :integer, default: 0
    field :charge, :integer, default: 0

    field :states, {:array, Ecto.Enum}, values: @states, virtual: true

    field :maximum_health, :integer, virtual: true, default: 0
    field :maximum_energy, :integer, virtual: true, default: 0
    field :health_regeneration, :integer, virtual: true, default: 0
    field :energy_regeneration, :integer, virtual: true, default: 0
    field :physical_armor, :integer, virtual: true, default: 0
    field :magical_armor, :integer, virtual: true, default: 0
    field :attack_speed, :integer, virtual: true, default: 0
    field :accuracy_rating, :integer, virtual: true, default: 0
    field :evasion_rating, :integer, virtual: true, default: 0
    field :critical_rating, :integer, virtual: true, default: 0
    field :recovery_rating, :integer, virtual: true, default: 0
    field :fortitude_rating, :integer, virtual: true, default: 0
    field :damage_penetration, :integer, virtual: true, default: 0
    field :damage_reflection, :integer, virtual: true, default: 0

    # Resistances
    field :fire_resistance, :integer, virtual: true, default: 0
    field :water_resistance, :integer, virtual: true, default: 0
    field :earth_resistance, :integer, virtual: true, default: 0
    field :air_resistance, :integer, virtual: true, default: 0

    # Current effects
    field :buffs, {:array, :map}, default: []
    field :debuffs, {:array, :map}, default: []

    field :action_patterns, {:array, :map}, default: [], virtual: true
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2

  def change_health(%Actor{} = actor, amount) do
    Map.update!(actor, :health, fn health ->
      max(0, min(max_health(actor), health + amount))
    end)
  end

  def change_energy(%Actor{} = actor, amount) do
    Map.update!(actor, :energy, fn energy ->
      max(0, min(max_energy(actor), energy + amount))
    end)
  end

  # TODO: Get max health including possible buffs
  def max_health(%Actor{maximum_health: max}), do: max

  # TODO: Get max energy including possible buffs
  def max_energy(%Actor{maximum_energy: max}), do: max

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
