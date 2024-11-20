defmodule GEMS.Engine.Schema.Creature do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
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
    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "creatures_traits"
    has_many :creatures_rewards, GEMS.Engine.Schema.CreatureReward
    has_many :creature_action_patterns, GEMS.Engine.Schema.CreatureActionPattern
  end

  @doc false
  def changeset(creature, attrs) do
    creature
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
