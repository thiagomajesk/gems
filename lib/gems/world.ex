defmodule GEMS.World do
  alias GEMS.Repo
  alias GEMS.World.Schema.Avatar

  import Ecto.Query

  def list_avatars() do
    Repo.all(Avatar)
  end

  def get_starting_zone() do
    Repo.one!(
      from z in GEMS.World.Schema.Zone,
        where: z.starting == true,
        order_by: fragment("RANDOM()"),
        limit: 1
    )
  end
end
