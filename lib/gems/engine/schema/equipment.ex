defmodule GEMS.Engine.Schema.Equipment do
  use GEMS.Database.Schema, :resource

  @slots [
    :trinket,
    :helmet,
    :cape,
    :main_hand,
    :armor,
    :off_hand,
    :ring,
    :boots,
    :amulet
  ]

  @required_fields [:name, :slot, :type_id]

  @optional_fields [
    :description,
    :icon,
    :price,
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
    :lehality
  ]

  schema "equipments" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :slot, Ecto.Enum, values: @slots
    field :price, :integer

    field :max_health, :integer
    field :max_energy, :integer
    field :physical_damage, :integer
    field :magical_damage, :integer
    field :physical_defense, :integer
    field :magical_defense, :integer
    field :health_regen, :integer
    field :energy_regen, :integer
    field :accuracy, :integer
    field :evasion, :integer
    field :attack_speed, :integer
    field :break_power, :integer
    field :critical_rating, :integer
    field :critical_power, :integer
    field :weapon_power, :integer
    field :ability_power, :integer
    field :resilience, :integer
    field :lehality, :integer

    has_many :traits, GEMS.Engine.Schema.Trait
    many_to_many :abilities, GEMS.Engine.Schema.Ability, join_through: "equipments_abilities"
    belongs_to :type, GEMS.Engine.Schema.EquipmentType
  end

  @doc false
  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> validate_required(@required_fields)
    |> assoc_constraint(:type)
  end
end
