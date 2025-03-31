defmodule GEMS.Battles do
  alias GEMS.Engine.Schema.ActionPattern
  alias GEMS.World.Schema.Character
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Battle

  def create_duel(%Character{} = character, %Creature{} = creature) do
    Battle.new([to_actor(creature, :alpha), to_actor(character, :bravo)])
  end

  defp to_actor(%Character{} = character, party) do
    %Actor{
      id: character.id,
      party: party,
      health: character.maximum_health,
      energy: character.maximum_energy,
      maximum_health: character.maximum_health,
      maximum_energy: character.maximum_energy,
      health_regeneration: character.health_regeneration,
      energy_regeneration: character.energy_regeneration,
      physical_armor: character.physical_armor,
      magical_armor: character.magical_armor,
      attack_speed: character.attack_speed,
      accuracy_rating: character.accuracy_rating,
      evasion_rating: character.evasion_rating,
      critical_rating: character.critical_rating,
      recovery_rating: character.recovery_rating,
      fortitude_rating: character.fortitude_rating,
      damage_penetration: character.damage_penetration,
      damage_reflection: character.damage_reflection,
      fire_resistance: character.fire_resistance,
      water_resistance: character.water_resistance,
      earth_resistance: character.earth_resistance,
      air_resistance: character.air_resistance
    }
    |> dbg()
  end

  defp to_actor(%Creature{} = creature, party) do
    %Actor{
      id: creature.id,
      party: party,
      health: creature.maximum_health,
      energy: creature.maximum_energy,
      maximum_health: creature.maximum_health,
      maximum_energy: creature.maximum_energy,
      health_regeneration: creature.health_regeneration,
      energy_regeneration: creature.energy_regeneration,
      physical_armor: creature.physical_armor,
      magical_armor: creature.magical_armor,
      attack_speed: creature.attack_speed,
      accuracy_rating: creature.accuracy_rating,
      evasion_rating: creature.evasion_rating,
      critical_rating: creature.critical_rating,
      recovery_rating: creature.recovery_rating,
      fortitude_rating: creature.fortitude_rating,
      damage_penetration: creature.damage_penetration,
      damage_reflection: creature.damage_reflection,
      fire_resistance: creature.fire_resistance,
      water_resistance: creature.water_resistance,
      earth_resistance: creature.earth_resistance,
      air_resistance: creature.air_resistance
      # action_patterns: Enum.map(creature.action_patterns, &cast_action_pattern/1)
    }
  end

  defp cast_action_pattern(%ActionPattern{} = _action_pattern) do
    %{}
  end
end
