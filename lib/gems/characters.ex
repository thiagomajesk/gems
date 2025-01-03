defmodule GEMS.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false

  alias GEMS.World.Schema.CharacterItem
  alias GEMS.World.Schema.CharacterProfession
  alias GEMS.Repo

  alias GEMS.Accounts.Schema.User
  alias GEMS.World.Schema.Character

  @doc """
  Returns the list of characters.
  """
  def list_characters(%User{id: user_id}) do
    Repo.all(from c in Character, where: c.user_id == ^user_id, preload: [:avatar])
  end

  @doc """
  Returns the list of professions for a character.
  """
  def list_character_professions(%Character{id: character_id}, preloads \\ []) do
    Repo.all(
      from cp in CharacterProfession,
        where: cp.character_id == ^character_id,
        preload: ^preloads
    )
  end

  @doc """
  Returns the list of items for a character.
  """
  def list_character_items(%Character{id: character_id}, preloads \\ []) do
    Repo.all(
      from ci in CharacterItem,
        where: ci.character_id == ^character_id,
        preload: ^preloads
    )
  end

  @doc """
  Gets a single character.
  """
  def get_character(%User{id: user_id}, id),
    do: Repo.get_by(Character, id: id, user_id: user_id)

  @doc """
  Gets the guild of a character.
  """
  def get_character_guild(%Character{id: character_id}) do
    Repo.one(
      from g in GEMS.World.Schema.Guild,
        join: m in assoc(g, :memberships),
        where: m.character_id == ^character_id,
        preload: [:memberships]
    )
  end

  @doc """
  Creates a character.
  """
  def create_character(%User{} = user, attrs \\ %{}) do
    %{id: zone_id} = GEMS.World.get_starting_zone()

    professions = GEMS.World.Schema.Profession.list()

    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_change(:max_health, 100)
    |> Ecto.Changeset.put_change(:max_energy, 100)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:zone_id, zone_id)
    |> Ecto.Changeset.put_assoc(:professions, professions)
    |> Repo.insert()
  end

  @doc """
  Returns a changeset for tracking character changes.
  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end
end
