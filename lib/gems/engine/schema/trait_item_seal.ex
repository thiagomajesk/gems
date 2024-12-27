defmodule GEMS.Engine.Schema.TraitItemSeal do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:item_id]

  schema "traits_item_seals" do
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_item_seal, attrs) do
    trait_item_seal
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:item)
  end
end
