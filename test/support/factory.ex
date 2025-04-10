defmodule GEMS.Factory do
  use ExMachina.Ecto, repo: GEMS.Repo

  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.ActionPattern

  @parties GEMS.Engine.Constants.parties()
  @triggers GEMS.Engine.Constants.triggers()

  def skill_factory do
    %Skill{
      id: Ecto.UUID.generate(),
      name: sequence(:name, &"skill-#{&1}"),
      action_cost: 0,
      affinity: :neutral,
      target_scope: :self,
      target_number: 1,
      random_targets: 0
    }
  end

  def action_pattern_factory do
    %ActionPattern{
      id: Ecto.UUID.generate(),
      priority: sequence(:priority, Enum.to_list(1..9)),
      trigger: sequence(:trigger, @triggers),
      skill: fn -> build(:skill) end
    }
  end

  def actor_factory do
    %Actor{
      id: Ecto.UUID.generate(),
      name: sequence(:name, &"actor-#{&1}"),
      party: sequence(:party, @parties),
      aggro: 0,
      charge: 0,
      action_points: 100,
      health: 100,
      damage: 10,
      accuracy: 0.5,
      evasion: 0.5,
      fortitude: 0.5,
      recovery: 0.5,
      maximum_health: 100,
      maximum_physical_armor: 10,
      maximum_magical_armor: 10,
      attack_speed: 10,
      critical_chance: 0.5,
      critical_multiplier: 0.5,
      damage_penetration: 0,
      damage_reflection: 0,
      health_regeneration: 0.1,
      fire_resistance: 0.5,
      water_resistance: 0.5,
      earth_resistance: 0.5,
      air_resistance: 0.5
    }
  end
end
