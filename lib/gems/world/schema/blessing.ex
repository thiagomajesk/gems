defmodule GEMS.World.Schema.Blessing do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :duration]

  schema "blessings" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :duration, :integer

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete
  end

  def build_changeset(blessing, attrs, opts) do
    changeset = super(blessing, attrs, opts)
    cast_embed(changeset, :icon)
  end
end
