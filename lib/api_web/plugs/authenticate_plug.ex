defmodule ReviewAppWeb.Plugs.Authenticate do
  import Plug.Conn

  alias ReviewAppWeb.Auth
  alias ReviewApp.Models.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case Auth.current_user(conn) do
      %User{} -> conn
      _ ->
        conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
