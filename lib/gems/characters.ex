defmodule GEMS.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias GEMS.Repo

  alias GEMS.Engine.Schema.Character

  @doc """
  Returns the number of active charactes.
  """
  def count_active_characters() do
    Repo.aggregate(Character, :count, :id)
  end
end
