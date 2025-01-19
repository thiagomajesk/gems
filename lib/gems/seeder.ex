defmodule GEMS.Seeder do
  @moduledoc false
  alias GEMS.Repo
  alias GEMS.Accounts.Schema.User

  require Logger

  def create_admin(password) do
    hash = Bcrypt.hash_pwd_salt(password)
    user = %User{email: "mail@domain.com", hashed_password: hash}
    Repo.insert!(user, on_conflict: :replace_all, conflict_target: :email)
  end

  def create_entities(module, entries) do
    Enum.each(entries, fn entry ->
      module_name = List.last(Module.split(module))
      Logger.debug("Seeding #{module_name} code=#{entry["code"]} id=#{entry["id"]}")
      upsert_entity!(module.seed_changeset(struct!(module), entry))
    end)
  end

  defp upsert_entity!(changeset, opts \\ []) do
    %{data: %{__struct__: module}} = changeset
    primary_keys = module.__schema__(:primary_key)

    conflict_target = Keyword.get(opts, :conflict_target, primary_keys)
    replace_except = Keyword.get(opts, :replace_except, [:id, :code, :hash])

    Repo.insert!(changeset,
      conflict_target: conflict_target,
      on_conflict: {:replace_all_except, replace_except}
    )
  end
end
