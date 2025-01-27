defmodule GEMS.Seeder do
  @moduledoc false
  alias GEMS.Repo
  alias GEMS.Accounts.Schema.User

  import Ecto.Query

  require Logger

  def create_admin(email, password) do
    hash = Bcrypt.hash_pwd_salt(password)
    user = %User{email: email, hashed_password: hash}
    Repo.insert!(user, on_conflict: :replace_all, conflict_target: :email)
  end

  def create_entities(module, entries) do
    Repo.transaction(fn ->
      Enum.each(entries, fn entry ->
        module_name = List.last(Module.split(module))
        Logger.notice("Seeding #{module_name} code=#{entry["code"]} id=#{entry["id"]}")
        manually_upsert_entity!(module.seed_changeset(struct!(module), entry))
      end)
    end)
  end

  # We need to manually upsert entities while seeding because we can't use standard upserts with relations.
  # Although less performatic, checking the entity exists first is simpler than decomposing the changeset
  # into separate inserts and then handling stale associations individually. The only thing should be
  # aware of is that the replaceable assocs need to be loaded and have `:on_replace` as `:delete`.
  defp manually_upsert_entity!(changeset) do
    %{data: %{__struct__: module}, changes: changes} = changeset

    case find_entity(module, changes.id) do
      nil ->
        Repo.insert!(changeset)

      entity ->
        entity
        |> Ecto.Changeset.change(changes)
        |> Repo.update!()
    end
  end

  def find_entity(module, id) do
    preloads = module.__collection__(:default_preloads)

    Repo.one(
      from q in module,
        where: q.id == ^id,
        preload: ^preloads
    )
  end
end
