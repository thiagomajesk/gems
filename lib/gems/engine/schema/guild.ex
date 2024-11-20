defmodule GEMS.Engine.Schema.Guild do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:description, :icon]

  schema "guilds" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  def changeset(guild, attrs) do
    guild
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
