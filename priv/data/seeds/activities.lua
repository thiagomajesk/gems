local items = require("seeds/items")
local zones = require("seeds/zones")
local professions = require("seeds/professions")

return {
  {
    id = "c879161d-9cc0-4de7-8575-aa1256409074",
    action = "Chop",
    zone_id = zones.blue_zone.id,
    duration = 10,
    experience = 10,
    profession_id = professions.gatherer.id,
    required_level = 0,
    item_id = items.wood.id
  },
  {
    id = "21be1b0b-f100-4a39-ac61-ec3b8e2822f7",
    action = "Mine",
    zone_id = zones.blue_zone.id,
    duration = 10,
    experience = 10,
    profession_id = professions.gatherer.id,
    required_level = 0,
    item_id = items.ore.id
  },
  {
    id = "d94c8421-a41d-4694-9aa2-728c5440999f",
    action = "Collect",
    zone_id = zones.blue_zone.id,
    duration = 10,
    experience = 10,
    profession_id = professions.gatherer.id,
    required_level = 0,
    item_id = items.red_herbs.id
  },
  {
    id = "90549fe8-af68-46e6-8282-85a8fff255cd",
    action = "Brew",
    zone_id = zones.blue_zone.id,
    duration = 50,
    experience = 10,
    profession_id = professions.craftsman.id,
    required_level = 0,
    item_id = items.energy_potion.id
  },
  {
    id = "fad3b64d-a271-45f9-8586-9add60bfed09",
    action = "Brew",
    zone_id = zones.blue_zone.id,
    duration = 50,
    experience = 10,
    profession_id = professions.craftsman.id,
    required_level = 0,
    item_id = items.health_potion.id
  }
}
