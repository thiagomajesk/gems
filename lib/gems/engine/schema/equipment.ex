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
      :physical_resistance,
      :maximum_health,
      :health_regeneration,
      :physical_damage,
      :physical_power,
      :evasion_rating,
      :attack_speed,
      :critical_rating,
      :accuracy_rating,
      :critical_power,
      :magical_resistance,
      :maximum_energy,
      :energy_regeneration,
      :magical_damage,
      :magical_power
    ],
    default_preloads: []

  @tiers GEMS.Engine.Constants.tiers()
  @affinities GEMS.Engine.Constants.attributes()
  @slots GEMS.Engine.Constants.slots()

  schema "equipments" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string
    field :slot, Ecto.Enum, values: @slots
    field :tier, Ecto.Enum, values: @tiers
    field :price, :integer

    # TODO: Affinity will increase the stats of the equipment based on the attribute
    # (souls-like equipment affinity mixed with combat triangle calculations)
    field :affinity, Ecto.Enum, values: @affinities

    field :physical_resistance_bonus, :float
    field :maximum_health_bonus, :float
    field :health_regeneration_bonus, :float
    field :physical_damage_bonus, :float
    field :physical_power_bonus, :float

    field :evasion_rating_bonus, :float
    field :attack_speed_bonus, :float
    field :critical_rating_bonus, :float
    field :accuracy_rating_bonus, :float
    field :critical_power_bonus, :float

    field :magical_resistance_bonus, :float
    field :maximum_energy_bonus, :float
    field :energy_regeneration_bonus, :float
    field :magical_damage_bonus, :float
    field :magical_power_bonus, :float

    field :recovery_rating_bonus, :float
    field :fortitude_rating_bonus, :float
    field :critical_resistance_bonus, :float
    field :damage_penetration_bonus, :float
    field :damage_reflection_bonus, :float

    field  :fire_damage_bonus, :float
    field  :fire_resistance_bonus, :float
    field  :water_damage_bonus, :float
    field  :water_resistance_bonus, :float
    field  :earth_damage_bonus, :float
    field  :earth_resistance_bonus, :float
    field  :air_damage_bonus, :float
    field  :air_resistance_bonus, :float

    belongs_to :type, GEMS.Engine.Schema.EquipmentType

    has_many :equipment_materials, GEMS.Engine.Schema.EquipmentMaterial, on_replace: :delete

    many_to_many :materials, GEMS.Engine.Schema.Item,
      join_through: GEMS.Engine.Schema.EquipmentMaterial

    many_to_many :skills, GEMS.Engine.Schema.Skill, join_through: "equipments_skills"
  end

  def build_changeset(equipment, attrs, opts) do
    changeset = super(equipment, attrs, opts)

    changeset
    |> cast_assoc(:skills, sort_param: :skills_sort, drop_param: :skills_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
