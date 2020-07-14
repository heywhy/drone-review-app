# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :review_app, ReviewApp, env: Mix.env()

config :review_app,
  namespace: ReviewApp,
  ecto_repos: [ReviewApp.Repo]

# Configures the endpoint
config :review_app, ReviewAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zjaWVYS2Q35E5VCZne4n4NH1yZQFFEem/ueYdwo27yERk6JyPfvlwljZqhjNq1nC",
  render_errors: [view: ReviewAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ReviewApp.PubSub,
  live_view: [signing_salt: "1irkT1xz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [
      default_scope: "user,repo,public_repo",
      send_redirect_uri: false
    ]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
