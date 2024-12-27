defmodule GEMS.World.Schema.GuildMembership do
  use GEMS.Database.Schema, preset: :default

  @roles [:leader, :officer, :member]

  @required_fields [:role, :guild_id, :character_id]

  @primary_key false
  schema "guilds_memberships" do
    field :role, Ecto.Enum, values: @roles

    belongs_to :guild, GEMS.World.Schema.Guild
    belongs_to :character, GEMS.World.Schema.Character
  end

  def changeset(guild_membership, attrs) do
    guild_membership
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:guild_id, :character_id)
  end
end
