defmodule ReviewApp.Repo do
  use Ecto.Repo,
    otp_app: :review_app,
    adapter: Ecto.Adapters.MyXQL

  use Paginator,
    limit: 10,
    maximum_limit: 15,
    include_total_count: true,
    total_count_primary_key_field: :id
end
