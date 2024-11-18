defmodule GEMS.Engine.Schema.Faction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "factions" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(faction, attrs) do
    faction
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
