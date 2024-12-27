defmodule GEMS.World.Schema.Avatar do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:name, :code, :icon]
  @optional_fields [:description]

  schema "avatars" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  @doc false
  def changeset(avatar, attrs) do
    build_changeset(avatar, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(avatar, attrs) do
    build_changeset(
      avatar,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  def build_changeset(avatar, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    avatar
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
