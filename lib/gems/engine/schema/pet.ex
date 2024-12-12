defmodule GEMS.Engine.Schema.Pet do
  use GEMS.Database.Schema, :resource

  @required_fields [:name]

  @optional_fields [:icon, :description]

  schema "pets" do
    field :name, :string
    field :icon, :string
    field :description, :string

    many_to_many :blessings, GEMS.Engine.Schema.Blessing, join_through: "pets_blessings"
  end

  @doc false
  def changeset(pet, attrs) do
    build_changeset(pet, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(pet, attrs) do
    build_changeset(
      pet,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(pet, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    pet
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
