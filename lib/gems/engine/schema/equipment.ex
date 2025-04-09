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
      :damage,
      :accuracy,
      :evasion,
      :fortitude,
      :recovery,
      :maximum_health,
      :maximum_physical_armor,
      :maximum_magical_armor,
      :attack_speed,
      :critical_chance,
      :critical_multiplier,
      :damage_penetration,
      :damage_reflection,
      :health_regeneration,
      :fire_resistance,
      :water_resistance,
      :earth_resistance,
      :air_resistance
    ],
    default_preloads: []

  @tiers GEMS.Engine.Constants.tiers()
  @slots GEMS.Engine.Constants.slots()

  schema "equipments" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :slot, Ecto.Enum, values: @slots
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer

    field :damage, :integer
    field :accuracy, :float
    field :evasion, :float
    field :fortitude, :float
    field :recovery, :float
    field :maximum_health, :integer
    field :maximum_physical_armor, :integer
    field :maximum_magical_armor, :integer
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

    belongs_to :type, GEMS.Engine.Schema.EquipmentType

    has_many :equipment_materials, GEMS.Engine.Schema.EquipmentMaterial, on_replace: :delete

    many_to_many :materials, GEMS.Engine.Schema.Item,
      join_through: GEMS.Engine.Schema.EquipmentMaterial
  end

  def build_changeset(equipment, attrs, opts) do
    changeset = super(equipment, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
