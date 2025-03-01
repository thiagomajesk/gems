defmodule GEMS.Leveling do
  @default_curve %{
    base_value: 100,
    extra_value: 50,
    inflation: 10,
    acceleration: 0.5,
    max_value: 1000
  }

  def experience(level) do
    GEMS.Database.ProgressCurve
    |> struct!(@default_curve)
    |> GEMS.Progression.value_for(level)
  end
end
