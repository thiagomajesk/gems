defmodule GEMS.Engine.Battler.Actor do
  alias __MODULE__

  defstruct [
    :__id__,
    :__party__,
    :__speed__,
    :__aggro__,
    :__charge__,
    :__health__,
    :__energy__,
    :__food__,
    :__potion__,
    :__spells__,
    :max_health,
    :max_energy,
    :physical_damage,
    :magical_damage,
    :physical_defense,
    :magical_defense,
    :health_regen,
    :energy_regen,
    :accuracy_rating,
    :evasion_rating,
    :attack_speed,
    :break_power,
    :critical_rating,
    :critical_power,
    :weapon_power,
    :ability_power
  ]

  def new(attrs) do
    Actor
    |> struct!(attrs)
    |> Map.put(:__id__, identity())
    |> Map.put(:__aggro__, 0)
    |> Map.put(:__speed__, 0)
    |> Map.put(:__charge__, 0)
    |> Map.put(:__health__, attrs[:max_health])
    |> Map.put(:__energy__, attrs[:max_energy])
  end

  def dead?(%Actor{} = actor), do: not alive?(actor)
  def alive?(%Actor{__health__: health}), do: health > 0
  def self?(%Actor{__id__: id1}, %Actor{__id__: id2}), do: id1 == id2
  def ally?(%Actor{__party__: p1}, %Actor{__party__: p2}), do: p1 == p2
  def enemy?(%Actor{__party__: p1}, %Actor{__party__: p2}), do: p1 != p2

  defp identity() do
    dict = [:colors, :animals]
    opts = %{style: :capital, separator: " "}
    UniqueNamesGenerator.generate(dict, opts)
  end
end
