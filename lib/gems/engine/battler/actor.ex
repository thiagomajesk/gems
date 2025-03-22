defmodule GEMS.Engine.Battler.Actor do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Schema.Trait

  @parties [:alpha, :bravo, :charlie, :delta]

  embedded_schema do
    field :party, Ecto.Enum, values: @parties
    field :health, :integer
    field :mana, :integer
    field :aggro, :integer
    field :charge, :integer

    field :armor_rating, :integer
    field :max_health, :integer
    field :health_regen, :integer
    field :attack_damage, :integer
    field :weapon_power, :integer
    field :evasion_rating, :integer
    field :attack_speed, :integer
    field :critical_rating, :integer
    field :accuracy_rating, :integer
    field :critical_power, :integer
    field :magic_resist, :integer
    field :max_mana, :integer
    field :mana_regen, :integer
    field :magic_damage, :integer
    field :skill_power, :integer

    field :items, {:array, :map}, default: [], virtual: true
    field :skills, {:array, :map}, default: [], virtual: true
    field :states, {:array, :map}, default: [], virtual: true

    field :action_patterns, {:array, :map}, default: [], virtual: true

    # TODO: Create custom type (SerializedReference / Snapshot) that allows serialization of a references schema so
    # we don't have to specify all the fields we want to serialize (pair with a protocol implementation).
    # We also should just handle plain maps inside the logic so serialization is easy enough. When building an actor
    # we should serialize everything first and work with the same format that we are going to persist.
    field :skills_sealed, {:array, :map}
    field :attack_skill, :map
    field :attack_element, :map
    field :attack_states, {:array, :map}
    field :parameter_rates, {:array, :map}
    field :element_rates, {:array, :map}

    # TODO: Probably need to remove this trait
    # because it doesn't make sense for in-combat mechanics.
    field :equipments_sealed, {:array, :map}
    field :items_sealed, {:array, :map}
    field :parameter_changes, {:array, :map}
    field :state_rates, {:array, :map}
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{health: health}), do: health > 0
  def self?(%Actor{id: id1}, %Actor{id: id2}), do: id1 == id2
  def ally?(%Actor{party: p1}, %Actor{party: p2}), do: p1 == p2
  def enemy?(%Actor{party: p1}, %Actor{party: p2}), do: p1 != p2

  def put_trait(%Actor{} = actor, %Trait{kind: :skill_seal} = trait) do
    %{skill_seal: %{skill: skill}} = trait
    Map.update!(actor, :skills_sealed, &[skill | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :attack_skill} = trait) do
    %{attack_skill: %{skill: skill}} = trait
    Map.put(actor, :attack_skill, skill)
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :attack_element} = trait) do
    %{attack_element: %{element: element}} = trait
    Map.put(actor, :attack_element, element)
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :attack_state} = trait) do
    %{attack_state: %{state: state}} = trait
    # TODO: Missing rate (%), use 1.0 for now
    Map.update!(actor, :attack_states, &[{state, 1.0} | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :parameter_rate} = trait) do
    %{parameter_rate: %{type: type, parameter: parameter, rate: rate}} = trait
    Map.update!(actor, :parameter_rates, &[{type, parameter, rate} | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :element_rate} = trait) do
    %{element_rate: %{element: element, rate: rate}} = trait
    Map.update!(actor, :element_rates, &[{element, rate} | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :equipment_seal} = trait) do
    %{equipment_seal: %{equipment: equipment}} = trait
    Map.update!(actor, :equipments_sealed, &[equipment | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :item_seal} = trait) do
    %{item_seal: %{item: item}} = trait
    Map.update!(actor, :items_sealed, &[item | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :parameter_change} = trait) do
    %{parameter_change: %{parameter: parameter, flat: flat, rate: rate}} = trait
    Map.update!(actor, :parameter_changes, &[{parameter, flat, rate} | &1])
  end

  def put_trait(%Actor{} = actor, %Trait{kind: :state_rate} = trait) do
    %{state_rate: %{state: state, rate: rate}} = trait
    Map.update!(actor, :state_rates, &[{state, rate} | &1])
  end
end
