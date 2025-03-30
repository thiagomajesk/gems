defmodule GEMS.Engine.Schema.Talent do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :class_id],
    optional_fields: [
      :description,
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
      :damage_reflection_bonus
    ],
    default_preloads: []

  schema "talents" do
    field :name, :string
    field :code, :string
    field :description, :string

    belongs_to :class, GEMS.Engine.Schema.Class

    field :maximum_health_bonus, :float
    field :maximum_energy_bonus, :float
    field :health_regeneration_bonus, :float
    field :energy_regeneration_bonus, :float
    field :physical_armor_bonus, :float
    field :magical_armor_bonus, :float
    field :attack_speed_bonus, :float
    field :accuracy_rating_bonus, :float
    field :evasion_rating_bonus, :float
    field :critical_rating_bonus, :float
    field :recovery_rating_bonus, :float
    field :fortitude_rating_bonus, :float
    field :damage_penetration_bonus, :float
    field :damage_reflection_bonus, :float
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
