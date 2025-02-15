defmodule GEMS.Engine.Schema.AbilityType do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "ability_types" do
    field :name, :string
    field :code, :string
    field :description, :string
  end

  def build_changeset(ability_type, attrs, opts) do
    changeset = super(ability_type, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
