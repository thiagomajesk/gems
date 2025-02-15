defmodule GEMS.World.Schema.Faction do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "factions" do
    field :name, :string
    field :code, :string
    field :description, :string

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
  end

  def build_changeset(faction, attrs, opts) do
    changeset = super(faction, attrs, opts)
    cast_embed(changeset, :icon)
  end
end
