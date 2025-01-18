import Config
import GEMS.Environment

if System.get_env("PHX_SERVER") do
  config :gems, GEMSWeb.Endpoint, server: true
end

if game_path = ensure_writable_dir!("GEMS_GAME_PATH") do
  config :gems, :game_path, game_path
end

if config_env() == :prod do
  # Example: ecto://USER:PASS@HOST/DATABASE
  database_url = ensure_env!("DATABASE_URL")

  config :gems, GEMS.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

  host = System.get_env("PHX_HOST", "localhost")
  port = String.to_integer(System.get_env("PORT", "4000"))

  config :gems, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :gems, GEMSWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: :any, port: port],
    secret_key_base: ensure_secret!("SECRET_KEY_BASE")
end
