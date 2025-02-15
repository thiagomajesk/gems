defmodule GEMS.Engine.Schema.Equipment do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [
      :name,
      :code,
      :slot,
      :type_id,
      :tier
    ],
    optional_fields: [
      :description,
      :image,
      :price,
      :armor_rating,
      :max_health,
      :health_regen,
      :attack_damage,
      :weapon_power,
      :evasion_rating,
      :attack_speed,
      :critical_rating,
      :accuracy_rating,
      :critical_power,
      :magic_resist,
      :max_energy,
      :energy_regen,
      :magic_damage,
      :ability_power
    ],
    default_preloads: [
      traits: [
        :ability_seal,
        :attack_ability,
        :attack_element,
        :attack_state,
        :element_rate,
        :equipment_seal,
        :item_seal,
        :parameter_change,
        :parameter_rate,
        :state_rate
      ]
    ]

  @tiers GEMS.Engine.Constants.tiers()

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
    field :image, :string
    field :slot, Ecto.Enum, values: @slots
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer

    # STR
    field :armor_rating, :integer
    field :max_health, :integer
    field :health_regen, :integer
    field :attack_damage, :integer
    field :weapon_power, :integer

    # DEX
    field :evasion_rating, :integer
    field :attack_speed, :integer
    field :critical_rating, :integer
    field :accuracy_rating, :integer
    field :critical_power, :integer

    # INT
    field :magic_resist, :integer
    field :max_energy, :integer
    field :energy_regen, :integer
    field :magic_damage, :integer
    field :ability_power, :integer

    belongs_to :type, GEMS.Engine.Schema.EquipmentType

    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
    has_many :equipment_materials, GEMS.Engine.Schema.EquipmentMaterial, on_replace: :delete

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
