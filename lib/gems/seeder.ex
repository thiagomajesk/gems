defmodule GEMS.Seeder do
  @moduledoc false

  alias GEMS.Repo
  alias GEMS.Accounts.Schema.User

  require Logger

  def insert_admin(email, password) do
    hash = Bcrypt.hash_pwd_salt(password)
    user = %User{email: email, hashed_password: hash}

    # We avoid replacing the id because of existing user tokens.
    # In fact, we want to allow updating only the email and password.
    Repo.insert!(user,
      on_conflict: {:replace, [:email, :hashed_password]},
      conflict_target: :email
    )
  end

  def insert_entities(module, entries) do
    Repo.transaction(fn ->
      Enum.each(entries, fn entry ->
        module_name = List.last(Module.split(module))
        Logger.notice("Seeding #{module_name} code=#{entry["code"]} id=#{entry["id"]}")
        insert_or_update_entity(module, entry)
      end)
    end)
  end

  # We need to manually "upsert" entities while seeding because we can't use standard upserts with relations.
  # Although less performatic, checking the entity exists first is simpler than decomposing the changeset
  # into separate inserts and then handling stale associations individually. The only thing we should be
  # aware of is that the replaceable assocs need to be loaded and have `:on_replace` set to `:delete`.
  defp insert_or_update_entity(module, entry) do
    preloads = module.__collection__(:default_preloads)

    module
    |> find_or_build(entry["id"])
    |> module.seed_changeset(entry)
    |> Repo.preload(preloads)
    |> Repo.insert_or_update!()
  end

  defp find_or_build(module, id) do
    case Repo.get(module, id) do
      nil -> struct!(module, id: id)
      entity -> entity
    end
  end
end
