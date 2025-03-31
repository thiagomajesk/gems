defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [
      :base_maximum_health,
      :base_maximum_energy,
      :base_health_regeneration,
      :base_energy_regeneration,
      :base_physical_armor,
      :base_magical_armor,
      :base_attack_speed,
      :base_accuracy_rating,
      :base_evasion_rating,
      :base_critical_rating,
      :base_recovery_rating,
      :base_fortitude_rating,
      :base_damage_penetration,
      :base_damage_reflection
    ],
    optional_fields: [:description],
    default_preloads: []

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string

    field :base_maximum_health, :integer
    field :base_maximum_energy, :integer
    field :base_health_regeneration, :integer
    field :base_energy_regeneration, :integer
    field :base_physical_armor, :integer
    field :base_magical_armor, :integer
    field :base_attack_speed, :integer
    field :base_accuracy_rating, :integer
    field :base_evasion_rating, :integer
    field :base_critical_rating, :integer
    field :base_recovery_rating, :integer
    field :base_fortitude_rating, :integer
    field :base_damage_penetration, :integer
    field :base_damage_reflection, :integer

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
