defmodule ReviewAppWeb.Plugs.Api do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.register_before_send(&include_header/1)
  end

  defp include_header(conn), do: conn |> put_resp_content_type("application/json")
end
