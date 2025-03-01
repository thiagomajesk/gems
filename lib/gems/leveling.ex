defmodule GEMS.Leveling do
  @class_curve %{
    base_value: 100,
    extra_value: 50,
    inflation: 10,
    acceleration: 0.5,
    max_value: 1000
  }

  @profession_curve %{
    base_value: 100,
    extra_value: 50,
    inflation: 10,
    acceleration: 0.5,
    max_value: 1000
  }

  def class_experience(level) do
    GEMS.Database.ProgressCurve
    |> struct!(@class_curve)
    |> GEMS.Progression.value_for(level)
  end

  def profession_experience(level) do
    GEMS.Database.ProgressCurve
    |> struct!(@profession_curve)
    |> GEMS.Progression.value_for(level)
  end
end
