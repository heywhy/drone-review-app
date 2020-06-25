use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :review_app, ReviewApp.Repo,
  username: System.get_env("DB_USERNAME", "root"),
  password: System.get_env("DB_PASSWORD", ""),
  database: System.get_env("DB_DATABASE", "api_test#{System.get_env("MIX_TEST_PARTITION")}"),
  hostname: System.get_env("DB_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :review_app, ReviewAppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
