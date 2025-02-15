defmodule GEMS.Engine.Schema.ItemType do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "item_types" do
    field :name, :string
    field :code, :string
    field :description, :string
  end

  def build_changeset(item_type, attrs, opts) do
    changeset = super(item_type, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
