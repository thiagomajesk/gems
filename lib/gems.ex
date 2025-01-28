defmodule GEMS do
  def manifest() do
    fallback = fn -> read_manifest(data_path()) end
    Cachex.fetch!(:gems, "manifest", fallback, expire: :timer.seconds(60))
  end

  def local_asset_path!(path_or_paths) do
    case local_asset_path(path_or_paths) do
      {:ok, asset_path} ->
        asset_path

      {:error, unknown_local_path} ->
        raise("Trying to serve an invalid local path: #{unknown_local_path}")
    end
  end

  def local_asset_path(path_or_paths) do
    # Ensures that we don't point to an invalid file path so the UI
    # has the chance to render the placeholder image instead.
    base_path = Path.join(data_path(), "assets")
    asset_path = Path.join([base_path | List.wrap(path_or_paths)])

    if File.exists?(asset_path), do: {:ok, asset_path}, else: {:error, asset_path}
  end

  def public_asset_path(paths_or_paths) do
    known_local_path = local_asset_path!(paths_or_paths)
    relative = Path.relative_to(known_local_path, data_path())
    Path.join([GEMSWeb.Endpoint.url(), "game", relative])
  end

  def data_path do
    Application.get_env(:gems, :game_path)
  end

  defp read_manifest(path) do
    path
    |> Path.join("manifest.json")
    |> File.read!()
    |> Jason.decode!()
  end
end
