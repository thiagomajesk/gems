defmodule GEMS.World.Schema.Character do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :name,
    :avatar_id,
    :faction_id,
    :strength,
    :dexterity,
    :intelligence
  ]

  @optional_fields [:title, :bio]

  schema "characters" do
    field :name, :string
    field :title, :string
    field :bio, :string

    field :strength, :integer, default: 0
    field :dexterity, :integer, default: 0
    field :intelligence, :integer, default: 0

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
    |> validate_attribute_values()
  end

  @doc false
  def validate_attribute_values(changeset) do
    max_points = 100

    strength = Ecto.Changeset.get_change(changeset, :strength, 0)
    dexterity = Ecto.Changeset.get_change(changeset, :dexterity, 0)
    intelligence = Ecto.Changeset.get_change(changeset, :intelligence, 0)

    case strength + dexterity + intelligence do
      total when total > max_points ->
        GEMSWeb.ErrorHelpers.add_new_error(
          changeset,
          :attributes,
          "The maximum amount of points is #{max_points}, you have distributed #{total}"
        )

      total when total < max_points ->
        GEMSWeb.ErrorHelpers.add_new_error(
          changeset,
          :attributes,
          "The minimum amount of points is #{max_points}, you have distributed #{total}"
        )

      ^max_points ->
        changeset
    end
  end
end
