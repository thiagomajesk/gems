defmodule GEMS.Engine.Schema.Creature do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [
      :name,
      :code,
      :type_id
    ],
    optional_fields: [
      :description,
      :image,
      :maximum_health,
      :maximum_energy,
      :health_regeneration,
      :energy_regeneration,
      :physical_armor,
      :magical_armor,
      :attack_speed,
      :accuracy_rating,
      :evasion_rating,
      :critical_rating,
      :recovery_rating,
      :fortitude_rating,
      :damage_penetration,
      :damage_reflection,
      :fire_resistance,
      :water_resistance,
      :earth_resistance,
      :air_resistance
    ],
    default_preloads: [:action_patterns]

  schema "creatures" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string

    field :maximum_health, :integer
    field :maximum_energy, :integer
    field :health_regeneration, :integer
    field :energy_regeneration, :integer
    field :physical_armor, :integer
    field :magical_armor, :integer
    field :attack_speed, :integer
    field :accuracy_rating, :integer
    field :evasion_rating, :integer
    field :critical_rating, :integer
    field :recovery_rating, :integer
    field :fortitude_rating, :integer
    field :damage_penetration, :integer
    field :damage_reflection, :integer

    # Resistances
    field :fire_resistance, :integer
    field :water_resistance, :integer
    field :earth_resistance, :integer
    field :air_resistance, :integer

    belongs_to :type, GEMS.Engine.Schema.CreatureType

    many_to_many :action_patterns, GEMS.Engine.Schema.ActionPattern,
      join_through: "creatures_action_patterns",
      on_replace: :delete
  end

  def build_changeset(creature, attrs, opts) do
    changeset = super(creature, attrs, opts)

    changeset
    |> cast_assoc(:action_patterns,
      sort_param: :action_patterns_sort,
      drop_param: :action_patterns_drop
    )
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
