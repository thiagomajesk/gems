defmodule GEMS.Engine.Schema.Element do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]

  schema "elements" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(element, attrs) do
    element
    |> cast(attrs, @required_fields ++ [:description, :icon])
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
