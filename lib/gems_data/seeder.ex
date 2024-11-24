defmodule GEMSData.Seeder do
  @moduledoc false
  alias GEMS.Repo

  require Logger

  def create_entities(module, entries) do
    Enum.map(entries, fn entry ->
      Logger.debug("Seeding #{module} #{entry["id"]}")
      upsert_entity!(module.change(struct!(module), entry))
    end)
  end

  def upsert_entity!(changeset, opts \\ []) do
    conflict_target = Keyword.get(opts, :conflict_target, :id)
    replace_except = Keyword.get(opts, :replace_except, [:id, :code, :hash])

    Repo.insert!(changeset,
      conflict_target: conflict_target,
      on_conflict: {:replace_all_except, replace_except}
    )
  end
end
