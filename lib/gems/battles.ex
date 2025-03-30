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
      party: party
    }
  end

  defp to_actor(%Creature{} = creature, party) do
    %Actor{
      id: creature.id,
      party: party,
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
      air_resistance: creature.air_resistance,
      action_patterns: Enum.map(creature.action_patterns, &cast_action_pattern/1)
    }
  end

  defp cast_action_pattern(%ActionPattern{} = _action_pattern) do
    %{}
  end
end
