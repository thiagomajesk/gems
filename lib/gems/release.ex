defmodule GEMS.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :gems

  import GEMS.Environment

  def migrate do
    :ok = load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(GEMS.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback(version) do
    :ok = load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(GEMS.Repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seeds do
    :ok = load_app()

    # Create default admin user
    password = ensure_env!("GEMS_ADMIN_PASSWORD")
    GEMS.Seeder.create_admin(password)

    # Trigger the on seeds hook
    GEMSLua.Manager.trigger_hook(:on_seeds)
  end

  defp load_app, do: Application.ensure_loaded(@app)
end
