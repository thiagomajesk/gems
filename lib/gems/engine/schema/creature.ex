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

  schema "creatures" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string

    # STR (Fire)
    field :physical_resistance, :integer, virtual: true
    field :maximum_health, :integer, virtual: true
    field :health_regeneration, :integer, virtual: true
    field :physical_damage, :integer, virtual: true
    field :physical_power, :integer, virtual: true

    # DEX (Air)
    field :evasion_rating, :integer, virtual: true
    field :attack_speed, :integer, virtual: true
    field :critical_rating, :integer, virtual: true
    field :accuracy_rating, :integer, virtual: true
    field :critical_power, :integer, virtual: true

    # INT (Water)
    field :magical_resistance, :integer, virtual: true
    field :maximum_energy, :integer, virtual: true
    field :energy_regeneration, :integer, virtual: true
    field :magical_damage, :integer, virtual: true
    field :magical_power, :integer, virtual: true

    # WIS (Earth)
    field :recovery_rating, :integer, virtual: true
    field :fortitude_rating, :integer, virtual: true
    field :critical_resistance, :integer, virtual: true
    field :damage_penetration, :integer, virtual: true
    field :damage_reflection, :integer, virtual: true

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
