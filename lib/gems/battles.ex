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
      armor_rating: creature.armor_rating,
      max_health: creature.max_health,
      health_regen: creature.health_regen,
      attack_damage: creature.attack_damage,
      weapon_power: creature.weapon_power,
      evasion_rating: creature.evasion_rating,
      attack_speed: creature.attack_speed,
      critical_rating: creature.critical_rating,
      accuracy_rating: creature.accuracy_rating,
      critical_power: creature.critical_power,
      magic_resist: creature.magic_resist,
      max_mana: creature.max_mana,
      mana_regen: creature.mana_regen,
      magic_damage: creature.magic_damage,
      skill_power: creature.skill_power,
      action_patterns: Enum.map(creature.action_patterns, &cast_action_pattern/1)
    }
  end

  defp cast_action_pattern(%ActionPattern{} = action_pattern) do
    %{
      skill: action_pattern.skill,
      state: action_pattern.state
    }
  end
end
