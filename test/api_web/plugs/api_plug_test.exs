defmodule ReviewAppWeb.ApiPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ReviewAppWeb.Router

  @opts Router.init([])

  test "includes 'content-type' header in response" do
    # Create a test connection
    conn = conn(:get, "/api/me")
    |> init_test_session(%{})

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the header and conn state
    assert conn.state == :sent
    assert Enum.any?(conn.resp_headers, fn header ->
      case header do
        {"content-type", value} ->
          String.contains?(value, "application/json")
        _ ->
          false
      end
    end)
  end
end
