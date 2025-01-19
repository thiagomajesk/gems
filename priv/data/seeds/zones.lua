local biomes = require("seeds/biomes")

return {
  blue_zone = {
    id = "4a199584-a52e-4371-bf85-afa7d7202e2e",
    name = "Blue Zone",
    code = "zone_blue",
    skull = "blue",
    starting = true,
    biome_id = biomes.jungle.id
  },
  yellow_zone = {
    id = "c0bcf5ea-5e51-4271-ae6a-dfef11cb8a10",
    name = "Yellow Zone",
    code = "zone_yellow",
    skull = "yellow",
    biome_id = biomes.jungle.id
  },
  red_zone = {
    id = "a33ade97-4223-4e70-b181-af126b90ebd8",
    name = "Red Zone",
    code = "zone_red",
    skull = "red",
    biome_id = biomes.jungle.id
  },
  black_zone = {
    id = "454620f7-3cca-469e-8dde-edcd961d2d50",
    name = "Black Zone",
    code = "zone_black",
    skull = "black",
    biome_id = biomes.jungle.id
  }
}
