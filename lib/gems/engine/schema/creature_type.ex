defmodule GEMS.Engine.Schema.CreatureType do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:description, :icon]

  schema "creature_types" do
    field :name, :string
    field :description, :string
    field :icon, :string
  end

  def changeset(creature_type, attrs) do
    creature_type
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
