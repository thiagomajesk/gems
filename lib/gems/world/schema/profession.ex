defmodule GEMS.World.Schema.Profession do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "professions" do
    field :name, :string
    field :code, :string
    field :description, :string

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
  end

  def build_changeset(profession, attrs, opts) do
    changeset = super(profession, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
