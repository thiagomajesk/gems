defmodule GEMS.Progression do
  @moduledoc """
  This module provides functions to calculate progression requirements using a customizable curve.
  """

  alias GEMS.Database.ProgressCurve

  def curve_table(%ProgressCurve{} = curve) do
    Enum.map(1..curve.max_value, fn level ->
      %{
        level: level,
        value: value_for(curve, level)
      }
    end)
  end

  def value_for(%ProgressCurve{} = curve, level) do
    %{
      base_value: base_value,
      extra_value: extra_value,
      inflation: inflation,
      acceleration: acceleration
    } = curve

    # Scale factors to handle 0-100 range inputs
    scaled_inflation = inflation / 100
    scaled_acceleration = acceleration / 50

    # Linear progression
    linear = base_value + extra_value * (level - 1)

    # Growth factor with diminishing returns
    growth = :math.pow(1 + scaled_inflation, level * scaled_acceleration)

    # Combine linear progression with exponential growth
    round(linear * growth)
  end

  def visualize_curve(curve) do
    items = curve_table(curve)

    %{level: max_level, value: max_value} = Enum.max_by(items, & &1.value)

    width = length(Integer.digits(max_level))

    Enum.each(items, fn %{level: level, value: value} ->
      # Calculate the relative size for the ASCII bar
      bar_size = max(round(value / max_value * 100), 1)

      bar_str = String.duplicate("*", bar_size)
      level_str = String.pad_leading(Integer.to_string(level), width, "0")
      value_str = IO.ANSI.format([:light_black, "[#{value}]"])

      IO.puts("L#{level_str}: #{bar_str} #{value_str}")
    end)
  end
end
