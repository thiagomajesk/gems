defmodule GEMSLua.API.Seeds do
  use Lua.API, scope: "GEMS.api.seeds"

  alias GEMS.Engine.Schema.Ability
  alias GEMS.Engine.Schema.AbilityType
  alias GEMS.Engine.Schema.Biome
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Schema.CreatureType
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Equipment
  alias GEMS.Engine.Schema.EquipmentType
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.ItemType
  alias GEMS.Engine.Schema.State
  alias GEMS.World.Schema.Activity
  alias GEMS.World.Schema.Avatar
  alias GEMS.World.Schema.Faction
  alias GEMS.World.Schema.Profession
  alias GEMS.World.Schema.Zone

  alias GEMS.Seeder

  require Logger

  deflua(create_abilities(table), do: create_entities(Ability, table))
  deflua(create_ability_types(table), do: create_entities(AbilityType, table))
  deflua(create_activities(table), do: create_entities(Activity, table))
  deflua(create_avatars(table), do: create_entities(Avatar, table))
  deflua(create_biomes(table), do: create_entities(Biome, table))
  deflua(create_creature_types(table), do: create_entities(CreatureType, table))
  deflua(create_creatures(table), do: create_entities(Creature, table))
  deflua(create_elements(table), do: create_entities(Element, table))
  deflua(create_equipment_types(table), do: create_entities(EquipmentType, table))
  deflua(create_equipments(table), do: create_entities(Equipment, table))
  deflua(create_factions(table), do: create_entities(Faction, table))
  deflua(create_item_types(table), do: create_entities(ItemType, table))
  deflua(create_items(table), do: create_entities(Item, table))
  deflua(create_professions(table), do: create_entities(Profession, table))
  deflua(create_states(table), do: create_entities(State, table))
  deflua(create_zones(table), do: create_entities(Zone, table))

  defp create_entities(module, table) when is_list(table) do
    entities = table_to_entities(table)

    case Seeder.create_entities(module, entities) do
      {:ok, result} -> result
      {:error, reason} -> raise inspect(reason)
    end
  end

  defp create_entities(module, invalid),
    do: raise("Expected a table for #{inspect(module)}, got: #{inspect(invalid)}")

  defp table_to_entities(table) do
    Logger.debug("table_to_entities: #{inspect(table)}")

    # The elixir type that we receive for tables is a kv list, so we need to convert it to a map.
    # Besides that Lua tables are do not preserve order, so we need to rely on additional metadata.
    # For that, we rely on a special `__order` key so we can issue inserts in the proper sequence.
    table
    |> Enum.map(fn {_key, table} -> Lua.Table.deep_cast(table) end)
    |> Enum.sort_by(&Map.get(&1, "__order"))
  end
end
