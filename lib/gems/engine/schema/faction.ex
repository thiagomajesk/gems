defmodule GEMS.Engine.Schema.Faction do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:description, :icon]

  schema "factions" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(faction, attrs) do
    faction
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
