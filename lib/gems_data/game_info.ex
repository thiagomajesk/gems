defmodule GEMSData.GameInfo do
  @directory Application.compile_env!(:gems, [:game, :directory])

  def data_path(paths \\ []), do: Path.join([@directory, "data"] ++ List.wrap(paths))
  def asset_path(paths \\ []), do: Path.join([@directory, "assets"] ++ List.wrap(paths))
end
