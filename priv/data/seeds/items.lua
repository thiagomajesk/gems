local types = require("seeds/item_types")

local items = {}

items.wood = {
  __order = 1,
  id = "2dc1d79d-77de-4a1f-b695-17cb81200612",
  name = "Wood",
  code = "item_wood",
  type_id = types.resource.id,
  tier = "t1",
}

items.red_herbs = {
  __order = 1,
  id = "4fa40ff7-f740-4392-a368-045cec0b7d1b",
  name = "Red Herbs",
  code = "item_red_herbs",
  type_id = types.resource.id,
  tier = "t1"
}

items.yellow_herbs = {
  __order = 1,
  id = "6356bb96-4db3-40a4-8a3b-c3cd2486ab92",
  name = "Yellow Herbs",
  code = "item_yellow_herbs",
  type_id = types.resource.id,
  tier = "t1"
}

items.ore = {
  __order = 1,
  id = "f615fd8f-194f-4537-b0c0-06842972f1e1",
  name = "Ore",
  code = "item_ore",
  type_id = types.resource.id,
  tier = "t1"
}

items.empty_bottle = {
  __order = 1,
  id = "54aa78b8-f8c2-455d-9738-d0f3b45ea0e1",
  name = "Empty Bottle",
  code = "item_empty_bottle",
  type_id = types.resource.id,
  tier = "t1"
}

items.health_potion = {
  __order = 2,
  id = "f954b393-04e9-49b9-a74e-f19ec3958c1f",
  name = "Health Potion",
  code = "item_health_potion",
  price = 5,
  type_id = types.potion.id,
  tier = "t1",
  target_side = "self",
  target_status = "alive",
  item_ingredients = {
    {
      amount = 1,
      ingredient_id = items.empty_bottle.id
    },
    {
      amount = 2,
      ingredient_id = items.red_herbs.id
    }
  }
}

items.energy_potion = {
  __order = 2,
  id = "8a245967-d7dc-47e7-8c2d-971423eb8fea",
  name = "Energy Potion",
  code = "item_energy_potion",
  price = 5,
  type_id = types.potion.id,
  tier = "t1",
  target_side = "self",
  target_status = "alive",
  item_ingredients = {
    {
      amount = 1,
      ingredient_id = items.empty_bottle.id
    },
    {
      amount = 2,
      ingredient_id = items.yellow_herbs.id
    }
  }
}

return items
