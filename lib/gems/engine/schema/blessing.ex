defmodule GEMS.Engine.Schema.Blessing do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :duration]
  @optional_fields [:icon, :description]

  schema "blessings" do
    field :name, :string
    field :icon, :string
    field :description, :string
    field :duration, :integer

    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "blessings_traits"
  end

  def changeset(blessing, attrs) do
    blessing
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
