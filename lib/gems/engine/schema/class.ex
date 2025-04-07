defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [
      :base_damage,
      :base_accuracy,
      :base_evasion,
      :base_fortitude,
      :base_recovery,
      :base_maximum_health,
      :base_maximum_energy,
      :base_physical_armor,
      :base_magical_armor,
      :base_attack_speed,
      :base_critical_chance,
      :base_critical_multiplier,
      :base_damage_penetration,
      :base_damage_reflection,
      :base_health_regeneration,
      :base_energy_regeneration,
      :base_fire_resistance,
      :base_water_resistance,
      :base_earth_resistance,
      :base_air_resistance
    ],
    optional_fields: [:description],
    default_preloads: []

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string

    field :base_damage, :integer
    field :base_accuracy, :float
    field :base_evasion, :float
    field :base_fortitude, :float
    field :base_recovery, :float
    field :base_maximum_health, :integer
    field :base_maximum_energy, :integer
    field :base_physical_armor, :integer
    field :base_magical_armor, :integer
    field :base_attack_speed, :integer
    field :base_critical_chance, :float
    field :base_critical_multiplier, :float
    field :base_damage_penetration, :integer
    field :base_damage_reflection, :integer
    field :base_health_regeneration, :float
    field :base_energy_regeneration, :float
    field :base_fire_resistance, :float
    field :base_water_resistance, :float
    field :base_earth_resistance, :float
    field :base_air_resistance, :float

    has_many :talents, GEMS.Engine.Schema.Talent
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> cast_assoc(:talents)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
