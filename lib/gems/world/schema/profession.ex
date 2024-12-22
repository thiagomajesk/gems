defmodule GEMS.World.Schema.Profession do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]

  @optional_fields [:description, :icon]

  schema "professions" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  def changeset(profession, attrs) do
    profession
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def seed_changeset(profession, attrs) do
    build_changeset(
      profession,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(profession, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    profession
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
