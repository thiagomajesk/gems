defmodule GEMS.Battles do
  alias GEMS.World.Schema.Character
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Battle

  def create_duel(%Character{} = character, %Creature{} = creature) do
    Battle.new([to_actor(creature, :red), to_actor(character, :blue)])
  end

  defp to_actor(%Character{} = character, party) do
    %Actor{
      id: character.id,
      party: party,
      health: 10 || character.max_health,
      mana: 10 || character.max_mana,
      armor_rating: 10 || character.armor_rating,
      max_health: 10 || character.max_health,
      health_regen: 10 || character.health_regen,
      attack_damage: 10 || character.attack_damage,
      weapon_power: 10 || character.weapon_power,
      evasion_rating: 10 || character.evasion_rating,
      attack_speed: 10 || character.attack_speed,
      critical_rating: 10 || character.critical_rating,
      accuracy_rating: 10 || character.accuracy_rating,
      critical_power: 10 || character.critical_power,
      magic_resist: 10 || character.magic_resist,
      max_mana: 10 || character.max_mana,
      mana_regen: 10 || character.mana_regen,
      magic_damage: 10 || character.magic_damage,
      skill_power: 10 || character.skill_power
    }
  end

  defp to_actor(%Creature{} = creature, party) do
    %Actor{
      id: creature.id,
      party: party,
      health: 10 || creature.max_health,
      mana: 10 || creature.max_mana,
      armor_rating: 10 || creature.armor_rating,
      max_health: 10 || creature.max_health,
      health_regen: 10 || creature.health_regen,
      attack_damage: 10 || creature.attack_damage,
      weapon_power: 10 || creature.weapon_power,
      evasion_rating: 10 || creature.evasion_rating,
      attack_speed: 10 || creature.attack_speed,
      critical_rating: 10 || creature.critical_rating,
      accuracy_rating: 10 || creature.accuracy_rating,
      critical_power: 10 || creature.critical_power,
      magic_resist: 10 || creature.magic_resist,
      max_mana: 10 || creature.max_mana,
      mana_regen: 10 || creature.mana_regen,
      magic_damage: 10 || creature.magic_damage,
      skill_power: 10 || creature.skill_power
    }
  end
end
