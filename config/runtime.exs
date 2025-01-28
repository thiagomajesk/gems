import Config
import GEMS.Environment

# Load the environment variables from
# existing .env files in the root folder
load_envs(config_env())

if use_server = ensure_env("PHX_SERVER", :boolean!) do
  config :gems, GEMSWeb.Endpoint, server: use_server
end

# Configures the directory where the game files are stored .
# In case we can't find the environment variable, we use the system's temporary directory.
# The environment variables needs to be a valid local path and be with read and write permissions.
config :gems, :game_path, ensure_game_path("GEMS_GAME_PATH", System.tmp_dir!())

config :gems, GEMS.Seeder,
  admin_email: ensure_env("GEMS_ADMIN_EMAIL", :string, "mail@domain.com"),
  admin_password: ensure_env("GEMS_ADMIN_PASSWORD", :string, "123123123")

if config_env() == :prod do
  # Example: ecto://USER:PASS@HOST/DATABASE
  database_url = ensure_env("DATABASE_URL", :string!)

  config :gems, GEMS.Repo,
    url: database_url,
    pool_size: ensure_env("POOL_SIZE", :integer!, 10)

  host = ensure_env("PHX_HOST", :string!, "localhost")
  port = ensure_env("PHX_PORT", :integer!, 4000)

  config :gems, :dns_cluster_query, ensure_env("DNS_CLUSTER_QUERY", :string)

  config :gems, GEMSWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: :any, port: port],
    secret_key_base: ensure_secret("GEMS_SECRET_KEY")
end
