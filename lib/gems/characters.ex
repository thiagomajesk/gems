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
    Repo.all(
      from c in Character,
        where: c.user_id == ^user_id,
        preload: [:faction, :class, :avatar]
    )
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
    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> patch_creation_changeset()
    |> Repo.insert()
  end

  @doc """
  Delivers a given amount of a specific item to a character.
  When the character already has the item, it increments the stack.
  """
  def give_item!(%Character{} = character, item_id, amount) do
    attrs = %{character_id: character.id, item_id: item_id, amount: amount}
    changeset = CharacterItem.changeset(%CharacterItem{}, attrs)

    Repo.insert!(changeset,
      conflict_target: [:character_id, :item_id],
      on_conflict: [inc: [amount: amount]]
    )
  end

  def give_experience!(%Character{} = character, amount) do
    exp_to_next_level = GEMS.Leveling.class_experience(character.level)

    {current_level, current_exp} =
      if character.experience + amount >= exp_to_next_level,
        do: {character.level + 1, 0},
        else: {character.level, character.experience + amount}

    character
    |> Ecto.Changeset.change(%{})
    |> Ecto.Changeset.put_change(:level, current_level)
    |> Ecto.Changeset.put_change(:experience, current_exp)
    |> Repo.update!()
  end

  def give_experience!(character, profession_id, amount) do
    character_profession =
      Repo.get_by!(CharacterProfession,
        character_id: character.id,
        profession_id: profession_id
      )

    {current_level, current_exp} =
      if character_profession.experience + amount >=
           GEMS.Leveling.class_experience(character_profession.level),
         do: {character_profession.level + 1, 0},
         else: {character_profession.level, character_profession.experience + amount}

    character_profession
    |> Ecto.Changeset.change(%{})
    |> Ecto.Changeset.put_change(:level, current_level)
    |> Ecto.Changeset.put_change(:experience, current_exp)
    |> Repo.update!()
  end

  @doc """
  Returns a changeset for tracking character changes.
  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  defp patch_creation_changeset(changeset) do
    Ecto.Changeset.prepare_changes(changeset, fn changeset ->
      faction_id = Ecto.Changeset.get_field(changeset, :faction_id)

      zone = GEMS.World.get_starting_zone(faction_id)
      professions = GEMS.World.Schema.Profession.list()

      initial_stamina = GEMS.Engine.Constants.max_stamina(1)

      changeset
      |> Ecto.Changeset.put_change(:souls, 10)
      |> Ecto.Changeset.put_change(:stamina, initial_stamina)
      |> Ecto.Changeset.put_change(:zone_id, zone.id)
      |> Ecto.Changeset.put_assoc(:professions, professions)
    end)
  end

  defp load_character(character) do
    character
    |> Repo.preload([:faction, :avatar, class: :talents])
    |> hydrate_character_virtuals()
  end

  defp hydrate_character_virtuals(character) do
    character
    |> merge_base_class_stats()
  end

  defp merge_base_class_stats(character) do
    %{
      character
      | damage: character.class.base_damage,
        accuracy: character.class.base_accuracy,
        evasion: character.class.base_evasion,
        fortitude: character.class.base_fortitude,
        recovery: character.class.base_recovery,
        maximum_health: character.class.base_maximum_health,
        maximum_energy: character.class.base_maximum_energy,
        physical_armor: character.class.base_physical_armor,
        magical_armor: character.class.base_magical_armor,
        attack_speed: character.class.base_attack_speed,
        critical_chance: character.class.base_critical_chance,
        critical_multiplier: character.class.base_critical_multiplier,
        damage_penetration: character.class.base_damage_penetration,
        damage_reflection: character.class.base_damage_reflection,
        health_regeneration: character.class.base_health_regeneration,
        energy_regeneration: character.class.base_energy_regeneration
    }
  end
end
