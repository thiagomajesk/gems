defmodule GEMSData.Lookup do
  @moduledoc false
  use GEMSData.Compiler

  import GEMSData.GameInfo

  embed_data(:abilities, data_path("abilities.json"), lookup: "code")
  embed_data(:ability_types, data_path("ability_types.json"), lookup: "code")
  embed_data(:biomes, data_path("biomes.json"), lookup: "code")
  embed_data(:creature_types, data_path("creature_types.json"), lookup: "code")
  embed_data(:creatures, data_path("creatures.json"), lookup: "code")
  embed_data(:elements, data_path("elements.json"), lookup: "code")
  embed_data(:equipment_types, data_path("equipment_types.json"), lookup: "code")
  embed_data(:equipments, data_path("equipments.json"), lookup: "code")
  embed_data(:item_types, data_path("item_types.json"), lookup: "code")
  embed_data(:items, data_path("items.json"), lookup: "code")
  embed_data(:professions, data_path("professions.json"), lookup: "code")
  embed_data(:states, data_path("states.json"), lookup: "code")

  embed_data(:avatars, data_path("avatars.json"), lookup: false)
  embed_data(:factions, data_path("factions.json"), lookup: false)
  embed_data(:zones, data_path("zones.json"), lookup: false)
  embed_data(:activities, data_path("activities.json"), lookup: false)
end
