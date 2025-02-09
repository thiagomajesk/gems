defmodule GEMS.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false

  alias GEMS.World.Schema.CharacterItem
  alias GEMS.World.Schema.CharacterEquipment
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
  Returns the list of equipments for a character.
  """
  def list_character_equipments(%Character{id: character_id}, preloads \\ []) do
    Repo.all(
      from ci in CharacterEquipment,
        where: ci.character_id == ^character_id,
        preload: ^preloads
    )
  end

  @doc """
  Gets a single character.
  """
  def get_character(%User{id: user_id}, id) do
    character = Repo.get_by(Character, id: id, user_id: user_id)
    with %Character{} = character <- character, do: load_character(character)
  end

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
  Delivers a given amount of a specific item to a character.
  When the character already has the item, it increments the stack.
  """
  def give_item!(character_id, item_id, amount) do
    attrs = %{character_id: character_id, item_id: item_id, amount: amount}
    changeset = CharacterItem.changeset(%CharacterItem{}, attrs)

    Repo.insert!(changeset,
      conflict_target: [:character_id, :item_id],
      on_conflict: [inc: [amount: amount]]
    )
  end

  def give_experience!(character_id, profession_id, amount) do
    attrs = %{character_id: character_id, profession_id: profession_id, experience: amount}
    changeset = CharacterProfession.changeset(%CharacterProfession{}, attrs)

    Repo.insert!(changeset,
      conflict_target: [:character_id, :profession_id],
      on_conflict: [inc: [experience: amount]]
    )
  end

  @doc """
  Returns a changeset for tracking character changes.
  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  defp load_character(character) do
    character
    |> preload_character()
    |> hydrate_virtuals()
  end

  defp preload_character(character) do
    Repo.preload(character, [
      :origin,
      :faction,
      :avatar
    ])
  end

  defp hydrate_virtuals(character) do
    character
    |> Map.put(:strength, calculate_strength(character))
    |> Map.put(:dexterity, calculate_dexterity(character))
    |> Map.put(:intelligence, calculate_intelligence(character))
  end

  defp calculate_strength(character) do
    character.origin.strength
  end

  defp calculate_dexterity(character) do
    character.origin.dexterity
  end

  defp calculate_intelligence(character) do
    character.origin.intelligence
  end
end
