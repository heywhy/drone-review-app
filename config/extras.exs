
import Mix.Config

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Set the environment variable for repository filters
config :review_app, ReviewApp,
  ui_url: System.get_env("UI_URL", "http://localhost:3000"),
  repository_filter: System.get_env("REPOSITORY_FILTER", "**")
