defmodule GEMS.Engine.Battler.Log do
  use Ecto.Schema

  alias __MODULE__

  @conditions GEMS.Engine.Constants.conditions()
  @types @conditions ++ [:damage, :regen, :drain, :buff, :debuff]

  embedded_schema do
    field :who, Ecto.Enum, values: [:target, :caster]
    field :type, Ecto.Enum, values: @types
    field :metadata, :map
  end

  def new(who, type, metadata) do
    metadata = Ecto.Type.dump(:map, metadata)
    %Log{who: who, type: type, metadata: metadata}
  end

  def health_damage(who, health), do: Log.new(who, :damage, health: health)
  def energy_damage(who, energy), do: Log.new(who, :damage, energy: energy)

  def health_regen(who, health), do: Log.new(who, :regen, health: health)
  def energy_regen(who, energy), do: Log.new(who, :regen, energy: energy)

  def health_drain(who, health), do: Log.new(who, :drain, health: health)
  def energy_drain(who, energy), do: Log.new(who, :drain, energy: energy)

  def condition(who, condition, duration),
    do: Log.new(who, condition, duration: duration)

  def change(who, assessment, stat, value, duration),
    do: Log.new(who, assessment, stat: stat, value: value, duration: duration)
end
