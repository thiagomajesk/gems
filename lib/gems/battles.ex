defmodule GEMS.Battles do
  alias GEMS.World.Schema.Character
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Battle

  def create_duel(%Character{} = character, %Creature{} = creature) do
    creature_actor = to_actor(creature, :alpha)
    character_actor = to_actor(character, :bravo)
    Battle.new([creature_actor, character_actor], type: :duel)
  end

  defp to_actor(%Character{} = character, party) do
    %Actor{
      id: character.id,
      name: character.name,
      party: party,
      health: character.maximum_health,
      physical_armor: character.maximum_physical_armor,
      magical_armor: character.maximum_magical_armor,
      damage: character.damage,
      accuracy: character.accuracy,
      evasion: character.evasion,
      fortitude: character.fortitude,
      recovery: character.recovery,
      maximum_health: character.maximum_health,
      maximum_physical_armor: character.maximum_physical_armor,
      maximum_magical_armor: character.maximum_magical_armor,
      attack_speed: character.attack_speed,
      critical_chance: character.critical_chance,
      critical_multiplier: character.critical_multiplier,
      damage_penetration: character.damage_penetration,
      damage_reflection: character.damage_reflection,
      health_regeneration: character.health_regeneration,
      fire_resistance: character.fire_resistance,
      water_resistance: character.water_resistance,
      earth_resistance: character.earth_resistance,
      air_resistance: character.air_resistance
    }
  end

  defp to_actor(%Creature{} = creature, party) do
    creature = GEMS.Engine.Schema.Creature.preload(creature)

    %Actor{
      id: creature.id,
      name: creature.name,
      party: party,
      health: creature.maximum_health,
      damage: creature.damage,
      physical_armor: creature.maximum_physical_armor,
      magical_armor: creature.maximum_magical_armor,
      accuracy: creature.accuracy,
      evasion: creature.evasion,
      fortitude: creature.fortitude,
      recovery: creature.recovery,
      maximum_health: creature.maximum_health,
      maximum_physical_armor: creature.maximum_physical_armor,
      maximum_magical_armor: creature.maximum_magical_armor,
      attack_speed: creature.attack_speed,
      critical_chance: creature.critical_chance,
      critical_multiplier: creature.critical_multiplier,
      damage_penetration: creature.damage_penetration,
      damage_reflection: creature.damage_reflection,
      health_regeneration: creature.health_regeneration,
      fire_resistance: creature.fire_resistance,
      water_resistance: creature.water_resistance,
      earth_resistance: creature.earth_resistance,
      air_resistance: creature.air_resistance,
      action_patterns: creature.action_patterns
    }
  end
end
