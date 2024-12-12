defmodule GEMS.Engine.Schema.CreatureType do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]

  @optional_fields [:description, :icon]

  schema "creature_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(creature_type, attrs) do
    build_changeset(creature_type, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(creature_type, attrs) do
    build_changeset(
      creature_type,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(creature_type, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    creature_type
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
