defmodule GEMS.Engine.Schema.TraitParameterRate do
  use Ecto.Schema
  import Ecto.Changeset

  @parameters [
    :max_health,
    :max_energy,
    :physical_damage,
    :magical_damage,
    :physical_defense,
    :magical_defense,
    :health_regen,
    :energy_regen,
    :accuracy,
    :evasion,
    :attack_speed,
    :break_power,
    :critical_rating,
    :critical_power,
    :weapon_power,
    :ability_power,
    :resilience,
    :lethality
  ]

  schema "traits_parameter_rates" do
    field :parameter, Ecto.Enum, values: @parameters
    field :modifier, :float, default: 1.0
  end

  @doc false
  def changeset(parameter_rate, attrs) do
    parameter_rate
    |> cast(attrs, [:parameter, :modifier])
    |> validate_required([:parameter])
    |> validate_number(:modifier, greater_than_or_equal_to: 0.0)
  end
end
