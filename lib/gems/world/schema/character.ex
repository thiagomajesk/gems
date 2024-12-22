defmodule GEMS.World.Schema.Character do
  use GEMS.Database.Schema, :default

  @required_fields [
    :name,
    :avatar_id,
    :faction_id
  ]

  @optional_fields [:title]

  schema "characters" do
    field :name, :string
    field :title, :string
    field :max_health, :integer
    field :max_energy, :integer

    belongs_to :faction, GEMS.World.Schema.Faction
    belongs_to :avatar, GEMS.World.Schema.Avatar
    belongs_to :user, GEMS.Accounts.Schema.User
    belongs_to :zone, GEMS.World.Schema.Zone

    has_many :character_professions, GEMS.World.Schema.CharacterProfession

    many_to_many :professions, GEMS.World.Schema.Profession,
      join_through: "characters_professions",
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
