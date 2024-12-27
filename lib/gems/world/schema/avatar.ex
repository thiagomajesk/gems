defmodule GEMS.World.Schema.Avatar do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name, :code, :icon],
    optional_fields: [:description]

  schema "avatars" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
