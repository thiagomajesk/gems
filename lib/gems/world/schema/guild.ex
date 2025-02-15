defmodule GEMS.World.Schema.Guild do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name],
    optional_fields: [:description]

  schema "guilds" do
    field :name, :string
    field :description, :string

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    has_many :memberships, GEMS.World.Schema.GuildMembership
    has_many :members, through: [:memberships, :character]
  end

  def build_changeset(guild, attrs, opts) do
    changeset = super(guild, attrs, opts)
    cast_embed(changeset, :icon)
  end
end
