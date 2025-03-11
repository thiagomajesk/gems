defmodule GEMS.Engine.Battler do
  alias GEMS.Engine.Battler.Battle

  def run(%Battle{status: nil} = battle), do: battle
  def run(%Battle{status: :running} = battle), do: run(Battle.next(battle))

  def seed(), do: Battle.new(actor_seed())

  defp actor_seed() do
    [
      GEMS.Engine.Battler.Actor.new(
        Map.merge(actor_factory(), %{
          __party__: :red
        })
      ),
      GEMS.Engine.Battler.Actor.new(
        Map.merge(actor_factory(), %{
          __party__: :blue
        })
      )
    ]
  end

  defp actor_factory() do
    %{
      max_health: 10000,
      max_energy: 10000,
      physical_damage: Enum.random(100..500),
      magical_damage: Enum.random(100..500),
      physical_defense: Enum.random(100..500),
      magical_defense: Enum.random(100..500),
      health_regen: Enum.random(100..500),
      energy_regen: Enum.random(100..500),
      accuracy_rating: Enum.random(500..900),
      evasion_rating: Enum.random(500..900),
      attack_speed: Enum.random(100..600),
      critical_rating: Enum.random(100..500),
      critical_power: 1500,
      weapon_power: Enum.random(500..900),
      ability_power: Enum.random(500..900),
      break_power: Enum.random(500..900)
    }
  end
end
