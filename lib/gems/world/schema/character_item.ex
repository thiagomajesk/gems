defmodule GEMS.World.Schema.CharacterItem do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:character_id, :item_id]
  @optional_fields [:amount]

  @primary_key false
  schema "characters_items" do
    field :amount, :integer

    belongs_to :character, GEMS.World.Schema.Character, primary_key: true
    belongs_to :item, GEMS.Engine.Schema.Item, primary_key: true
  end

  @doc false
  def changeset(character_item, attrs) do
    character_item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
