defmodule GEMS.Engine.Schema.Creature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "creatures" do
    field :name, :string
    field :description, :string
    field :max_health, :integer, default: 0
    field :max_energy, :integer, default: 0
    field :physical_damage, :integer, default: 0
    field :magical_damage, :integer, default: 0
    field :physical_defense, :integer, default: 0
    field :magical_defense, :integer, default: 0
    field :health_regen, :integer, default: 0
    field :energy_regen, :integer, default: 0
    field :accuracy, :integer, default: 0
    field :evasion, :integer, default: 0
    field :attack_speed, :integer, default: 0
    field :break_power, :integer, default: 0
    field :critical_rating, :integer, default: 0
    field :critical_power, :integer, default: 0
    field :weapon_power, :integer, default: 0
    field :ability_power, :integer, default: 0
    field :resilience, :integer, default: 0
    field :lehality, :integer, default: 0

    has_many :creatures_traits, GEMS.Engine.Schema.CreatureTrait
    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "creatures_traits"
    has_many :creatures_rewards, GEMS.Engine.Schema.CreatureReward
    many_to_many :items, GEMS.Engine.Schema.Item, join_through: "creatures_rewards"
    has_many :creature_action_patterns, GEMS.Engine.Schema.CreatureActionPattern

    many_to_many :action_patterns, GEMS.Engine.Schema.ActionPattern,
      join_through: "creature_action_patterns"
  end

  @doc false
  def changeset(creature, attrs) do
    creature
    |> cast(attrs, [
      :name,
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
    ])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
