defmodule GEMS.World do
  alias GEMS.Repo
  alias GEMS.World.Schema.Avatar
  alias GEMS.World.Schema.Zone
  alias GEMS.World.Schema.Character
  alias GEMS.World.Schema.Activity

  import Ecto.Query

  def list_avatars() do
    Repo.all(Avatar)
  end

  def list_nearby_zones(zone_id) do
    Repo.all(from z in Zone, where: z.nearby_id == ^zone_id, preload: [:biome])
  end

  def get_starting_zone(faction_id) do
    Repo.one!(
      from z in GEMS.World.Schema.Zone,
        where: z.starting == true,
        where: is_nil(z.faction_id) or z.faction_id == ^faction_id,
        order_by: fragment("RANDOM()"),
        limit: 1
    )
  end

  def list_available_activities(%Character{} = character) do
    %{zone_id: zone_id} = character

    Repo.all(
      from a in Activity,
        where: a.zone_id == ^zone_id,
        preload: [:profession, item: [item_ingredients: :ingredient]]
    )
  end
end
