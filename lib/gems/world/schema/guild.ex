defmodule GEMS.World.Schema.Guild do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:description, :icon]

  schema "guilds" do
    field :name, :string
    field :description, :string
    field :icon, :string

    has_many :memberships, GEMS.World.Schema.GuildMembership
    has_many :members, through: [:memberships, :character]
  end

  def changeset(guild, attrs) do
    guild
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
