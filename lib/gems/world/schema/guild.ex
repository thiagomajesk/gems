defmodule GEMS.World.Schema.Guild do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name],
    optional_fields: [:description, :icon]

  schema "guilds" do
    field :name, :string
    field :description, :string
    field :icon, :string

    has_many :memberships, GEMS.World.Schema.GuildMembership
    has_many :members, through: [:memberships, :character]
  end
end
