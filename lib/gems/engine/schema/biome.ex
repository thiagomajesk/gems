defmodule GEMS.Engine.Schema.Biome do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:description, :icon]

  schema "biomes" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(biome, attrs) do
    biome
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
