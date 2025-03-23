defmodule GEMS.Engine.Schema.Trait do
  use GEMS.Database.Schema, preset: :default

  @kinds [
    :skill_seal,
    :attack_skill,
    :attack_element,
    :attack_state,
    :parameter_rate,
    :element_rate,
    :equipment_seal,
    :item_seal,
    :parameter_change,
    :state_rate
  ]

  @required_fields [:kind]

  schema "traits" do
    field :kind, Ecto.Enum, values: @kinds

    belongs_to :state, GEMS.Engine.Schema.State
    belongs_to :class, GEMS.Engine.Schema.Class
    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :equipment, GEMS.Engine.Schema.Equipment

    has_one :skill_seal, GEMS.Engine.Schema.TraitSkillSeal, on_replace: :delete
    has_one :attack_skill, GEMS.Engine.Schema.TraitAttackSkill, on_replace: :delete
    has_one :attack_element, GEMS.Engine.Schema.TraitAttackElement, on_replace: :delete
    has_one :attack_state, GEMS.Engine.Schema.TraitAttackState, on_replace: :delete
    has_one :parameter_rate, GEMS.Engine.Schema.TraitParameterRate, on_replace: :delete
    has_one :element_rate, GEMS.Engine.Schema.TraitElementRate, on_replace: :delete
    # TODO: Remove equipment seal because it doesn't make sense during battle
    has_one :equipment_seal, GEMS.Engine.Schema.TraitEquipmentSeal, on_replace: :delete
    has_one :item_seal, GEMS.Engine.Schema.TraitItemSeal, on_replace: :delete
    has_one :parameter_change, GEMS.Engine.Schema.TraitParameterChange, on_replace: :delete
    has_one :state_rate, GEMS.Engine.Schema.TraitStateRate, on_replace: :delete
  end

  def changeset(trait, attrs) do
    trait
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:state)
    |> assoc_constraint(:class)
    |> assoc_constraint(:creature)
    |> assoc_constraint(:equipment)
    |> cast_assoc(:skill_seal)
    |> cast_assoc(:attack_skill)
    |> cast_assoc(:attack_element)
    |> cast_assoc(:attack_state)
    |> cast_assoc(:parameter_rate)
    |> cast_assoc(:element_rate)
    |> cast_assoc(:equipment_seal)
    |> cast_assoc(:item_seal)
    |> cast_assoc(:parameter_change)
    |> cast_assoc(:state_rate)
  end
end
