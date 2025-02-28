defmodule GEMS.World do
  alias GEMS.Repo
  alias GEMS.World.Schema.Avatar
  alias GEMS.World.Schema.Zone
  alias GEMS.World.Schema.Portal
  alias GEMS.World.Schema.Character
  alias GEMS.World.Schema.Activity

  import Ecto.Query

  def list_avatars() do
    Repo.all(Avatar)
  end

  def list_nearby_zones(zone_id) do
    preloads = Zone.__collection__(:default_preloads)

    exits =
      from p in Portal,
        where: p.target_id == ^zone_id,
        select: p.origin_id

    # For the time being, we assume all portals are two way passages.
    # Meaning an exit to one zone is also an entrance to another.
    # With that, we can double-link zones and make traveling easier.
    entrances =
      from p in Portal,
        where: p.origin_id == ^zone_id,
        select: p.target_id

    Repo.all(
      from z in Zone,
        where: z.id in subquery(exits),
        or_where: z.id in subquery(entrances),
        preload: ^preloads
    )
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

  def travel(%Character{} = character, zone_id) do
    zone = Repo.get!(Zone, zone_id)

    attrs = %{
      zone_id: zone_id,
      gold: max(character.gold - zone.gold_cost, 0),
      stamina: max(character.stamina - zone.stamina_cost, 0)
    }

    character
    |> Ecto.Changeset.change(attrs)
    |> Repo.update!()
  end
end
