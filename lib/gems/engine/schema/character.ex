defmodule GEMS.Engine.Schema.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :name, :string
    field :title, :string
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

    belongs_to :faction, GEMS.Engine.Schema.Faction
    belongs_to :user, GEMS.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [
      :name,
      :title,
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
      :lehality,
      :faction_id,
      :user_id
    ])
    |> validate_required([:name, :faction_id, :user_id])
    |> unique_constraint(:name)
  end
end
