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
      physical_resistance: creature.physical_resistance,
      maximum_health: creature.maximum_health,
      health_regeneration: creature.health_regeneration,
      physical_damage: creature.physical_damage,
      physical_power: creature.physical_power,
      evasion_rating: creature.evasion_rating,
      attack_speed: creature.attack_speed,
      critical_rating: creature.critical_rating,
      accuracy_rating: creature.accuracy_rating,
      critical_power: creature.critical_power,
      magical_resistance: creature.magical_resistance,
      maximum_energy: creature.maximum_energy,
      energy_regeneration: creature.energy_regeneration,
      magical_damage: creature.magical_damage,
      magical_power: creature.magical_power,
      action_patterns: Enum.map(creature.action_patterns, &cast_action_pattern/1)
    }
  end

  defp cast_action_pattern(%ActionPattern{} = _action_pattern) do
    %{}
  end
end
