defmodule GEMSData.Lookup do
  @moduledoc false
  use GEMSData.Compiler

  @directory Application.compile_env!(:gems, [:game, :directory])

  embed_data(:abilities, Path.join([@directory, "data/abilities.json"]))
  embed_data(:ability_types, Path.join([@directory, "data/ability_types.json"]))
  embed_data(:biomes, Path.join([@directory, "data/biomes.json"]))
  embed_data(:creature_types, Path.join([@directory, "data/creature_types.json"]))
  embed_data(:creatures, Path.join([@directory, "data/creatures.json"]))
  embed_data(:elements, Path.join([@directory, "data/elements.json"]))
  embed_data(:equipment_types, Path.join([@directory, "data/equipment_types.json"]))
  embed_data(:equipments, Path.join([@directory, "data/equipments.json"]))
  embed_data(:item_types, Path.join([@directory, "data/item_types.json"]))
  embed_data(:items, Path.join([@directory, "data/items.json"]))
  embed_data(:professions, Path.join([@directory, "data/professions.json"]))
  embed_data(:states, Path.join([@directory, "data/states.json"]))
end
