defmodule GEMS.World.Schema.CharacterEquipment do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:character_id, :equipment_id]

  @primary_key false
  schema "characters_equipments" do
    belongs_to :character, GEMS.World.Schema.Character, primary_key: true
    belongs_to :equipment, GEMS.Engine.Schema.Equipment, primary_key: true
  end

  @doc false
  def changeset(character_item, attrs) do
    character_item
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end