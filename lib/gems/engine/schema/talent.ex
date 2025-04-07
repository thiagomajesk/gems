defmodule GEMS.Engine.Schema.Talent do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :class_id],
    optional_fields: [
      :description,
      :damage_bonus,
      :accuracy_bonus,
      :evasion_bonus,
      :fortitude_bonus,
      :recovery_bonus,
      :maximum_health_bonus,
      :maximum_energy_bonus,
      :physical_armor_bonus,
      :magical_armor_bonus,
      :attack_speed_bonus,
      :critical_chance_bonus,
      :critical_multiplier_bonus,
      :damage_penetration_bonus,
      :damage_reflection_bonus,
      :health_regeneration_bonus,
      :energy_regeneration_bonus,
      :fire_resistance_bonus,
      :water_resistance_bonus,
      :earth_resistance_bonus,
      :air_resistance_bonus
    ],
    default_preloads: []

  schema "talents" do
    field :name, :string
    field :code, :string
    field :description, :string

    belongs_to :class, GEMS.Engine.Schema.Class

    field :damage_bonus, :integer
    field :accuracy_bonus, :float
    field :evasion_bonus, :float
    field :fortitude_bonus, :float
    field :recovery_bonus, :float
    field :maximum_health_bonus, :integer
    field :maximum_energy_bonus, :integer
    field :physical_armor_bonus, :integer
    field :magical_armor_bonus, :integer
    field :attack_speed_bonus, :integer
    field :critical_chance_bonus, :float
    field :critical_multiplier_bonus, :float
    field :damage_penetration_bonus, :integer
    field :damage_reflection_bonus, :integer
    field :health_regeneration_bonus, :float
    field :energy_regeneration_bonus, :float
    field :fire_resistance_bonus, :float
    field :water_resistance_bonus, :float
    field :earth_resistance_bonus, :float
    field :air_resistance_bonus, :float
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
