defmodule GEMS.World.Schema.Profession do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :icon]

  schema "professions" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  def build_changeset(profession, attrs, opts) do
    changeset = super(profession, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
