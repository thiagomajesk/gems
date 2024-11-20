defmodule GEMS.Engine.Schema.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :faction_id, :user_id]
  @optional_fields [
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
    :lehality
  ]

  schema "characters" do
    field :name, :string
    field :title, :string
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

    belongs_to :faction, GEMS.Engine.Schema.Faction
    belongs_to :user, GEMS.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
