defmodule GEMSLua.API.Seeds do
  use Lua.API, scope: "GEMS.api.seeds"

  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.SkillType
  alias GEMS.World.Schema.Biome
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
  alias GEMS.World.Schema.Blessing
  alias GEMS.World.Schema.Faction
  alias GEMS.Engine.Schema.Class
  alias GEMS.World.Schema.Profession
  alias GEMS.World.Schema.Zone

  alias GEMS.Seeder

  require Logger

  deflua insert_skills(table), do: insert_entities(Skill, table)
  deflua insert_skill_types(table), do: insert_entities(SkillType, table)
  deflua insert_activities(table), do: insert_entities(Activity, table)
  deflua insert_avatars(table), do: insert_entities(Avatar, table)
  deflua insert_biomes(table), do: insert_entities(Biome, table)
  deflua insert_blessings(table), do: insert_entities(Blessing, table)
  deflua insert_creature_types(table), do: insert_entities(CreatureType, table)
  deflua insert_creatures(table), do: insert_entities(Creature, table)
  deflua insert_elements(table), do: insert_entities(Element, table)
  deflua insert_equipment_types(table), do: insert_entities(EquipmentType, table)
  deflua insert_equipments(table), do: insert_entities(Equipment, table)
  deflua insert_factions(table), do: insert_entities(Faction, table)
  deflua insert_item_types(table), do: insert_entities(ItemType, table)
  deflua insert_items(table), do: insert_entities(Item, table)
  deflua insert_classes(table), do: insert_entities(Class, table)
  deflua insert_professions(table), do: insert_entities(Profession, table)
  deflua insert_states(table), do: insert_entities(State, table)
  deflua insert_zones(table), do: insert_entities(Zone, table)

  defp insert_entities(module, table) when is_list(table) do
    entries = table_to_entries(table)

    case Seeder.insert_entities(module, entries) do
      {:ok, result} -> result
      {:error, reason} -> raise inspect(reason)
    end
  end

  defp insert_entities(module, invalid),
    do: raise("Expected a table for #{inspect(module)}, got: #{inspect(invalid)}")

  # The elixir type that we receive for tables is a kv list, so we need to convert it to a map.
  # Besides that Lua tables are do not preserve order, so we need to rely on additional metadata.
  # For that, we rely on a special `__order` key so we can issue inserts in the proper sequence.
  defp table_to_entries(table) do
    Logger.debug("Casting table: #{inspect(table)}")

    table
    |> Enum.map(&cast_lua_table/1)
    |> Enum.sort_by(&Map.get(&1, "__order"))
  end

  defp cast_lua_table({key, table}) when is_binary(key) do
    table
    |> Lua.Table.deep_cast()
    |> Map.put_new("code", key)
  end

  defp cast_lua_table(other),
    do: raise("Expected a table with named keys, got: #{inspect(other)}")
end
