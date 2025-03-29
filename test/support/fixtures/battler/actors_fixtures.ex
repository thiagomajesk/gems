defmodule GEMS.Battler.ActorsFixtures do
  alias GEMS.Engine.Battler.Actor

  def build(:dummy) do
    %Actor{
      party: nil,
      health: 10,
      energy: 10,
      aggro: 0,
      charge: 0,
      armor_rating: 1,
      max_health: 1,
      health_regen: 1,
      attack_damage: 1,
      attack_power: 1,
      evasion_rating: 1,
      attack_speed: 1,
      critical_rating: 1,
      accuracy_rating: 1,
      critical_power: 1,
      magic_resist: 1,
      max_energy: 1,
      energy_regen: 1,
      magic_damage: 1,
      magic_power: 1
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end
end
