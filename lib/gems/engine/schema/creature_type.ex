defmodule GEMS.Engine.Schema.CreatureType do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :icon]

  schema "creature_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
  end

  def build_changeset(creature_type, attrs, opts) do
    changeset = super(creature_type, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
