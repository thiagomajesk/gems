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

    field :strength, :integer, virtual: true
    field :dexterity, :integer, virtual: true
    field :intelligence, :integer, virtual: true

    # STR
    field :armor_rating, :integer, virtual: true
    field :max_health, :integer, virtual: true
    field :health_regen, :integer, virtual: true
    field :attack_damage, :integer, virtual: true
    field :attack_power, :integer, virtual: true

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
    field :magic_power, :integer, virtual: true

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
