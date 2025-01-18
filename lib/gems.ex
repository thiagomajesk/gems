defmodule GEMS do
  def manifest() do
    fallback = fn -> read_manifest(data_path()) end
    Cachex.fetch!(:gems, "manifest", fallback, expire: :timer.seconds(60))
  end

  def game_assets_endpoint(paths_or_paths) do
    path = Path.join(["assets" | List.wrap(paths_or_paths)])
    # Ensures that we don't point to an invalid file path so the UI
    # has the chance to render the placeholder image instead.
    if File.exists?(path), do: Path.join(GEMSWeb.Endpoint.url(), path), else: nil
  end

  def data_path do
    Application.get_env(:gems, :game_path) ||
      Application.app_dir(:gems, "priv/data")
  end

  defp read_manifest(path) do
    path
    |> Path.join("manifest.json")
    |> File.read!()
    |> Jason.decode!()
  end
end
