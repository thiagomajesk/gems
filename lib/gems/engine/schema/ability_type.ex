defmodule GEMS.Engine.Schema.AbilityType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ability_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(ability_type, attrs) do
    ability_type
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
