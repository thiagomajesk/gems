defmodule GEMS.Engine.Schema.Talent do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :class_id],
    optional_fields: [
      :description,
      :damage,
      :accuracy,
      :evasion,
      :fortitude,
      :recovery,
      :maximum_health,
      :maximum_energy,
      :physical_armor,
      :magical_armor,
      :attack_speed,
      :critical_chance,
      :critical_multiplier,
      :damage_penetration,
      :damage_reflection,
      :health_regeneration,
      :energy_regeneration,
      :fire_resistance,
      :water_resistance,
      :earth_resistance,
      :air_resistance
    ],
    default_preloads: []

  schema "talents" do
    field :name, :string
    field :code, :string
    field :description, :string

    belongs_to :class, GEMS.Engine.Schema.Class

    field :damage, :integer
    field :accuracy, :float
    field :evasion, :float
    field :fortitude, :float
    field :recovery, :float
    field :maximum_health, :integer
    field :maximum_energy, :integer
    field :physical_armor, :integer
    field :magical_armor, :integer
    field :attack_speed, :integer
    field :critical_chance, :float
    field :critical_multiplier, :float
    field :damage_penetration, :integer
    field :damage_reflection, :integer
    field :health_regeneration, :float
    field :energy_regeneration, :float
    field :fire_resistance, :float
    field :water_resistance, :float
    field :earth_resistance, :float
    field :air_resistance, :float
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
