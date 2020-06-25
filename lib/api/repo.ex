defmodule ReviewApp.Repo do
  use Ecto.Repo,
    otp_app: :review_app,
    adapter: Ecto.Adapters.MyXQL
end
