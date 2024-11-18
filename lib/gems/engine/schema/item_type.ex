defmodule GEMS.Engine.Schema.ItemType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(item_type, attrs) do
    item_type
    |> cast(attrs, [:name, :description, :icon])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
