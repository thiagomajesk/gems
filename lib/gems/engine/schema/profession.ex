defmodule GEMS.Engine.Schema.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "professions" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :icon, :string
    field :max_level, :integer, default: 99
  end

  @doc false
  def changeset(profession, attrs) do
    profession
    |> cast(attrs, [:name, :description, :type, :icon, :max_level])
    |> validate_required([:name, :type])
    |> unique_constraint(:name)
  end
end
