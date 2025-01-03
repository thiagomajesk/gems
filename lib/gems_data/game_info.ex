defmodule GEMSData.GameInfo do
  @directory Application.compile_env!(:gems, [:game, :directory])

  @starting_character_points Application.compile_env!(:gems, [:game, :starting_character_points])

  def data_path(paths \\ []), do: Path.join([@directory, "data"] ++ List.wrap(paths))
  def asset_path(paths \\ []), do: Path.join([@directory, "assets"] ++ List.wrap(paths))

  def starting_character_points, do: @starting_character_points
end
