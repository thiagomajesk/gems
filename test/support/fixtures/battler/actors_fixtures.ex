defmodule GEMS.Battler.ActorsFixtures do
  alias GEMS.Engine.Battler.Actor

  def build(:dummy) do
    %Actor{
      party: nil,
      health: 10,
      energy: 10,
      aggro: 0,
      charge: 0,
      maximum_health: 1,
      maximum_energy: 1,
      health_regeneration: 1,
      energy_regeneration: 1,
      physical_armor: 1,
      magical_armor: 1,
      attack_speed: 1,
      accuracy_rating: 1,
      evasion_rating: 1,
      critical_rating: 1,
      recovery_rating: 1,
      fortitude_rating: 1,
      damage_penetration: 1,
      damage_reflection: 1,
      fire_resistance: 1,
      water_resistance: 1,
      earth_resistance: 1,
      air_resistance: 1
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end
end
