defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description],
    default_preloads: []

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
