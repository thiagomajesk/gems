defmodule GEMS.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :gems

  def migrate do
    ensure_started()
    {:ok, _, _} = Ecto.Migrator.with_repo(GEMS.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback(version) do
    ensure_started()
    {:ok, _, _} = Ecto.Migrator.with_repo(GEMS.Repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seeds do
    ensure_started()

    {:ok, _, _} =
      Ecto.Migrator.with_repo(GEMS.Repo, fn _repo ->
        seeds_file = "#{:code.priv_dir(@app)}/repo/seeds.exs"
        File.regular?(seeds_file) && Code.eval_file(seeds_file)
      end)
  end

  defp ensure_started do
    Application.ensure_loaded(@app)
    Application.ensure_all_started(:gems)
  end
end
