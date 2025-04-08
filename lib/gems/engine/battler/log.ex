defmodule GEMS.Engine.Battler.Log do
  use Ecto.Schema

  alias __MODULE__

  @conditions GEMS.Engine.Constants.conditions()
  @types @conditions ++ [:damage, :regen, :drain, :buff, :debuff]

  @primary_key false
  embedded_schema do
    field :who, Ecto.Enum, values: [:target, :caster]
    field :type, Ecto.Enum, values: @types
    field :metadata, :map
  end

  def new(who, type, opts) do
    %Log{who: who, type: type, metadata: cast_opts(opts)}
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

  defp cast_opts(opts) do
    opts
    |> Enum.into(%{})
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
