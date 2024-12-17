defmodule GEMS.World do
  alias GEMS.Repo
  alias GEMS.World.Schema.Avatar

  def list_avatars() do
    Repo.all(Avatar)
  end
end
