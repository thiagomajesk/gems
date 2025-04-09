defmodule GEMS.World.Schema.Character do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :name,
    :class_id,
    :avatar_id,
    :faction_id
  ]

  @optional_fields [:title, :bio]

  schema "characters" do
    field :name, :string
    field :title, :string
    field :bio, :string

    field :level, :integer
    field :experience, :integer
    field :gold, :integer
    field :souls, :integer
    field :stamina, :integer
    field :fame, :integer

    field :damage, :integer, virtual: true
    field :accuracy, :float, virtual: true
    field :evasion, :float, virtual: true
    field :fortitude, :float, virtual: true
    field :recovery, :float, virtual: true
    field :maximum_health, :integer, virtual: true
    field :maximum_physical_armor, :integer, virtual: true
    field :maximum_magical_armor, :integer, virtual: true
    field :attack_speed, :integer, virtual: true
    field :critical_chance, :float, virtual: true
    field :critical_multiplier, :float, virtual: true
    field :damage_penetration, :integer, virtual: true
    field :damage_reflection, :integer, virtual: true
    field :health_regeneration, :float, virtual: true
    field :fire_resistance, :float, virtual: true
    field :water_resistance, :float, virtual: true
    field :earth_resistance, :float, virtual: true
    field :air_resistance, :float, virtual: true

    belongs_to :class, GEMS.Engine.Schema.Class
    belongs_to :faction, GEMS.World.Schema.Faction
    belongs_to :avatar, GEMS.World.Schema.Avatar
    belongs_to :user, GEMS.Accounts.Schema.User
    belongs_to :zone, GEMS.World.Schema.Zone

    has_one :guild_membership, GEMS.World.Schema.GuildMembership
    has_one :guild, through: [:guild_membership, :guild]

    has_many :character_professions, GEMS.World.Schema.CharacterProfession, on_replace: :delete
    has_many :character_items, GEMS.World.Schema.CharacterItem, on_replace: :delete

    many_to_many :professions, GEMS.World.Schema.Profession,
      join_through: GEMS.World.Schema.CharacterProfession

    many_to_many :items, GEMS.Engine.Schema.Item, join_through: GEMS.World.Schema.CharacterItem

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
