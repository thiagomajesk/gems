defmodule GEMS.Battler.ActorsFixtures do
  alias GEMS.Engine.Battler.Actor

  def build(:dummy) do
    %Actor{
      party: nil,
      health: 10,
      energy: 10,
      aggro: 0,
      charge: 0,
      physical_resistance: 1,
      maximum_health: 1,
      health_regeneration: 1,
      physical_damage: 1,
      physical_power: 1,
      evasion_rating: 1,
      attack_speed: 1,
      critical_rating: 1,
      accuracy_rating: 1,
      critical_power: 1,
      magical_resistance: 1,
      maximum_energy: 1,
      energy_regeneration: 1,
      magical_damage: 1,
      magical_power: 1
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end
end
