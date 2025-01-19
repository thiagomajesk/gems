local types = require("seeds/ability_types")

return {
  attack = {
    id = "93ca47fa-0c08-4342-95d4-58c8845d6a7e",
    name = "Attack",
    code = "ability_attack",
    description = "Attack the target",
    type_id = types.magic.id,
    health_cost = 0,
    energy_cost = 0,
    hit_type = "physical_attack",
    success_rate = 1.0,
    repeats = 1,
    target_side = "enemy",
    target_status = "alive",
    target_number = 1,
    random_targets = 0
  }
}
