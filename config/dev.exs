import Config

# Configure your database
config :gems, GEMS.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "gems_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Disable any cache and enable debugging and code reloading.
config :gems, GEMSWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "REfBdpjcI4Fui2JJ25JdfN0ncFi/OzHZ0uFkC8yC/0JE4kKLnu9hYCIGYjZtJoyN",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:gems, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:gems, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :gems, GEMSWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/gems_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :gems, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Include HEEx debug annotations as HTML comments in rendered markup
# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
