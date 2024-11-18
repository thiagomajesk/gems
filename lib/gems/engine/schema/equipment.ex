defmodule GEMS.Engine.Schema.Equipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipments" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :slot_type, :string
    field :tier, :integer, default: 0
    field :price, :integer
    field :stackable, :boolean, default: false
    field :hidden, :boolean, default: false
    field :sellable, :boolean, default: false
    field :max_health, :integer, default: 0
    field :max_energy, :integer, default: 0
    field :physical_damage, :integer, default: 0
    field :magical_damage, :integer, default: 0
    field :physical_defense, :integer, default: 0
    field :magical_defense, :integer, default: 0
    field :health_regen, :integer, default: 0
    field :energy_regen, :integer, default: 0
    field :accuracy, :integer, default: 0
    field :evasion, :integer, default: 0
    field :attack_speed, :integer, default: 0
    field :break_power, :integer, default: 0
    field :critical_rating, :integer, default: 0
    field :critical_power, :integer, default: 0
    field :weapon_power, :integer, default: 0
    field :ability_power, :integer, default: 0
    field :resilience, :integer, default: 0
    field :lehality, :integer, default: 0

    belongs_to :type, GEMS.Engine.Schema.EquipmentType
    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "equipments_traits"
    many_to_many :abilities, GEMS.Engine.Schema.Ability, join_through: "equipments_abilities"
  end

  @doc false
  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, [
      :name,
      :description,
      :icon,
      :slot_type,
      :tier,
      :price,
      :stackable,
      :hidden,
      :sellable,
      :max_health,
      :max_energy,
      :physical_damage,
      :magical_damage,
      :physical_defense,
      :magical_defense,
      :health_regen,
      :energy_regen,
      :accuracy,
      :evasion,
      :attack_speed,
      :break_power,
      :critical_rating,
      :critical_power,
      :weapon_power,
      :ability_power,
      :resilience,
      :lehality,
      :type_id
    ])
    |> validate_required([:name, :slot_type, :type_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:type)
  end
end
