defmodule GEMS.Engine.Schema.CharacterProfession do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:character_id, :profession_id]
  @optional_fields [:level, :exp]

  @primary_key false
  schema "characters_professions" do
    field :level, :integer
    field :exp, :integer

    belongs_to :character, GEMS.Engine.Schema.Character, primary_key: true
    belongs_to :profession, GEMS.Engine.Schema.Profession, primary_key: true
  end

  @doc false
  def changeset(character_profession, attrs) do
    character_profession
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
