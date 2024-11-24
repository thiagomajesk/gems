defmodule GEMS.Engine.Schema.Creature do
  use GEMS.Database.Schema, :resource

  @required_fields [
    :name,
    :type_id,
    :biome_id
  ]

  @optional_fields [
    :description,
    :max_health,
    :max_energy,
    :physical_damage,
    :magical_damage,
    :physical_defense,
    :magical_defense,
    :health_regen,
    :energy_regen,
    :accuracy,
    :evasion,
    :attack_speed,
    :break_power,
    :critical_rating,
    :critical_power,
    :weapon_power,
    :ability_power,
    :resilience,
    :lehality
  ]

  schema "creatures" do
    field :name, :string
    field :description, :string
    field :max_health, :integer
    field :max_energy, :integer
    field :physical_damage, :integer
    field :magical_damage, :integer
    field :physical_defense, :integer
    field :magical_defense, :integer
    field :health_regen, :integer
    field :energy_regen, :integer
    field :accuracy, :integer
    field :evasion, :integer
    field :attack_speed, :integer
    field :break_power, :integer
    field :critical_rating, :integer
    field :critical_power, :integer
    field :weapon_power, :integer
    field :ability_power, :integer
    field :resilience, :integer
    field :lehality, :integer

    belongs_to :biome, GEMS.Engine.Schema.Biome
    belongs_to :type, GEMS.Engine.Schema.CreatureType
    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
    has_many :action_patterns, GEMS.Engine.Schema.CreatureActionPattern
  end

  @doc false
  def changeset(creature, attrs) do
    creature
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
