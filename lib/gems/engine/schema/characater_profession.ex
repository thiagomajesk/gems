defmodule GEMS.Engine.Schema.CharacterProfession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters_professions" do
    belongs_to :character, GEMS.Engine.Schema.Character
    belongs_to :profession, GEMS.Engine.Schema.Profession
    field :level, :integer, default: 0
    field :exp, :integer, default: 0
  end

  @doc false
  def changeset(character_profession, attrs) do
    character_profession
    |> cast(attrs, [:character_id, :profession_id, :level, :exp])
    |> validate_required([:character_id, :profession_id])
  end
end
