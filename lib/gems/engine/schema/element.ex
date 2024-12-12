defmodule GEMS.Engine.Schema.Element do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]
  @optional_fields [:description, :icon]

  schema "elements" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(element, attrs) do
    build_changeset(element, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(element, attrs) do
    build_changeset(
      element,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(element, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    element
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
