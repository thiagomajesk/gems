defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [
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
    optional_fields: [:description],
    default_preloads: []

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string

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
