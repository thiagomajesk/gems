defmodule GEMS.World.Schema.Origin do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [
      :name,
      :code,
      :strength,
      :dexterity,
      :intelligence,
      :blessing_id
    ],
    optional_fields: [
      :description,
      :icon
    ]

  schema "origins" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :strength, :integer
    field :dexterity, :integer
    field :intelligence, :integer
    field :icon, :string

    belongs_to :blessing, GEMS.World.Schema.Blessing
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
