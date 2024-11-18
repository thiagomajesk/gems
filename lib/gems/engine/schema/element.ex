defmodule GEMS.Engine.Schema.Element do
  use Ecto.Schema
  import Ecto.Changeset

  schema "elements" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(element, attrs) do
    element
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
