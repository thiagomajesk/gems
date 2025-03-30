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
      :maximum_health_bonus,
      :maximum_energy_bonus,
      :health_regeneration_bonus,
      :energy_regeneration_bonus,
      :physical_armor_bonus,
      :magical_armor_bonus,
      :attack_speed_bonus,
      :accuracy_rating_bonus,
      :evasion_rating_bonus,
      :critical_rating_bonus,
      :recovery_rating_bonus,
      :fortitude_rating_bonus,
      :damage_penetration_bonus,
      :damage_reflection_bonus,
      :fire_resistance_bonus,
      :water_resistance_bonus,
      :earth_resistance_bonus,
      :air_resistance_bonus
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

    field :maximum_health_bonus, :float, virtual: true
    field :maximum_energy_bonus, :float, virtual: true
    field :health_regeneration_bonus, :float, virtual: true
    field :energy_regeneration_bonus, :float, virtual: true
    field :physical_armor_bonus, :float, virtual: true
    field :magical_armor_bonus, :float, virtual: true
    field :attack_speed_bonus, :float, virtual: true
    field :accuracy_rating_bonus, :float, virtual: true
    field :evasion_rating_bonus, :float, virtual: true
    field :critical_rating_bonus, :float, virtual: true
    field :recovery_rating_bonus, :float, virtual: true
    field :fortitude_rating_bonus, :float, virtual: true
    field :damage_penetration_bonus, :float, virtual: true
    field :damage_reflection_bonus, :float, virtual: true

    # Resistances
    field :fire_resistance_bonus, :float, virtual: true
    field :water_resistance_bonus, :float, virtual: true
    field :earth_resistance_bonus, :float, virtual: true
    field :air_resistance_bonus, :float, virtual: true

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
