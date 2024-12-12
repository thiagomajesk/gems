defmodule GEMS.Engine.Schema.Blessing do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :duration]

  @optional_fields [:icon, :description]

  schema "blessings" do
    field :name, :string
    field :icon, :string
    field :description, :string
    field :duration, :integer

    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "blessings_traits"
  end

  @doc false
  def changeset(blessing, attrs) do
    build_changeset(blessing, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(blessing, attrs) do
    build_changeset(
      blessing,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(blessing, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    blessing
    |> cast(attrs, required_fields ++ optional_fields)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
