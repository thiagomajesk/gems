defmodule GEMS.World.Schema.Character do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :name,
    :avatar_id,
    :faction_id
  ]

  @optional_fields [:title, :bio]

  schema "characters" do
    field :name, :string
    field :title, :string
    field :bio, :string

    field :strength, :integer
    field :dexterity, :integer
    field :intelligence, :integer

    # STR
    field :armor_rating, :integer, virtual: true
    field :max_health, :integer, virtual: true
    field :health_regen, :integer, virtual: true
    field :attack_damage, :integer, virtual: true
    field :weapon_power, :integer, virtual: true

    # DEX
    field :evasion_rating, :integer, virtual: true
    field :attack_speed, :integer, virtual: true
    field :critical_rating, :integer, virtual: true
    field :accuracy_rating, :integer, virtual: true
    field :critical_power, :integer, virtual: true

    # INT
    field :magic_resist, :integer, virtual: true
    field :max_energy, :integer, virtual: true
    field :energy_regen, :integer, virtual: true
    field :magic_damage, :integer, virtual: true
    field :ability_power, :integer, virtual: true

    belongs_to :faction, GEMS.World.Schema.Faction
    belongs_to :avatar, GEMS.World.Schema.Avatar
    belongs_to :user, GEMS.Accounts.Schema.User
    belongs_to :zone, GEMS.World.Schema.Zone

    has_one :guild_membership, GEMS.World.Schema.GuildMembership
    has_one :guild, through: [:guild_membership, :guild]

    has_many :character_professions, GEMS.World.Schema.CharacterProfession
    has_many :character_items, GEMS.World.Schema.CharacterItem

    many_to_many :professions, GEMS.World.Schema.Profession,
      join_through: "characters_professions",
      on_replace: :delete

    many_to_many :items, GEMS.Engine.Schema.Item,
      join_through: "characters_items",
      on_replace: :delete

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
