defmodule GEMS.Engine.Schema.Equipment do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [
      :name,
      :code,
      :slot,
      :type_id
    ],
    optional_fields: [
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

  schema "equipments" do
    field :name, :string
    field :code, :string
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

    belongs_to :type, GEMS.Engine.Schema.EquipmentType
    has_many :traits, GEMS.Engine.Schema.Trait
    has_many :equipment_materials, GEMS.Engine.Schema.EquipmentMaterial
    many_to_many :materials, GEMS.Engine.Schema.Item, join_through: "equipments_materials"
    many_to_many :abilities, GEMS.Engine.Schema.Ability, join_through: "equipments_abilities"
  end

  def build_changeset(equipment, attrs, opts) do
    changeset = super(equipment, attrs, opts)

    changeset
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> cast_assoc(:abilities, sort_param: :abilities_sort, drop_param: :abilities_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
