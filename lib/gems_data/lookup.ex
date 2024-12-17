defmodule GEMSData.Lookup do
  @moduledoc false
  use GEMSData.Compiler

  import GEMSData.GameInfo

  embed_data(:abilities, data_path("abilities.json"))
  embed_data(:ability_types, data_path("ability_types.json"))
  embed_data(:biomes, data_path("biomes.json"))
  embed_data(:creature_types, data_path("creature_types.json"))
  embed_data(:creatures, data_path("creatures.json"))
  embed_data(:elements, data_path("elements.json"))
  embed_data(:equipment_types, data_path("equipment_types.json"))
  embed_data(:equipments, data_path("equipments.json"))
  embed_data(:item_types, data_path("item_types.json"))
  embed_data(:items, data_path("items.json"))
  embed_data(:professions, data_path("professions.json"))
  embed_data(:states, data_path("states.json"))

  embed_data(:avatars, data_path("avatars.json"))
  embed_data(:factions, data_path("factions.json"))
end
