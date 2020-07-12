
import Mix.Config

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Set the environment variable for repository filters
config :review_app, ReviewApp,
  repository_filter: System.get_env("REPOSITORY_FILTER", "**")
