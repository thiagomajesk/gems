defmodule GEMS.Engine.Schema.State do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :priority],
    default_preloads: []

  schema "states" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :priority, :integer
    field :max_stack, :integer

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
  end

  def build_changeset(state, attrs, opts) do
    changeset = super(state, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
