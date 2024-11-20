defmodule GEMS.Engine.Schema.AbilityType do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:description, :icon]

  schema "ability_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(ability_type, attrs) do
    ability_type
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
