defmodule GEMS.Engine.Schema.Profession do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :type]

  @optional_fields [:description, :icon]

  @types [
    :gathering,
    :crafting,
    :farming,
    :combat
  ]

  schema "professions" do
    field :name, :string
    field :description, :string
    field :type, Ecto.Enum, values: @types
    field :icon, :string
  end

  def changeset(profession, attrs) do
    profession
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
