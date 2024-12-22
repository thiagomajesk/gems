defmodule GEMS.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias GEMS.Repo

  alias GEMS.Accounts.Schema.User
  alias GEMS.World.Schema.Character

  @doc """
  Returns the list of characters.
  """
  def list_characters(%User{id: user_id}) do
    Repo.all(from c in Character, where: c.user_id == ^user_id)
  end

  @doc """
  Gets a single character.
  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  Creates a character.
  """
  def create_character(%User{} = user, attrs \\ %{}) do
    %{id: zone_id} = GEMS.World.get_starting_zone()

    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:zone_id, zone_id)
    |> Repo.insert()
  end

  @doc """
  Returns the number of active charactes.
  """
  def count_active_characters() do
    Repo.aggregate(Character, :count, :id)
  end

  @doc """
  Returns a changeset for tracking character changes.
  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end
end
