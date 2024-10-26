defmodule GEMS.Repo do
  use Ecto.Repo,
    otp_app: :gems,
    adapter: Ecto.Adapters.Postgres
end
