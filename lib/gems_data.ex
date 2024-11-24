defmodule GEMSData do
  @moduledoc """
  This contains lookup information relative to the files inside the data directory.
  Its sole purpose is to make the seeding and upgrading process of game data easier.
  """

  alias GEMS.Accounts.Schema.User

  def seed_admin(password) do
    hash = Bcrypt.hash_pwd_salt(password)
    user = %User{email: "mail@domain.com", hashed_password: hash}
    GEMS.Repo.insert!(user, on_conflict: :replace_all, conflict_target: :email)
  end
end
