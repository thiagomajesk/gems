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
    default_preloads: [action_patterns: :skill]

  schema "creatures" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string

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
