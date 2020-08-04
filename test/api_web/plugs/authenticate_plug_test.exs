defmodule ReviewAppWeb.AuthenticatePlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ReviewAppWeb.Router
  alias ReviewApp.Factory

  @opts Router.init([])

  test "should return 401" do
    # Create a test connection
    conn = conn(:get, "/api/me") |> init_test_session(%{})

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the header and conn state
    assert conn.status == 401
    assert conn.resp_body == "Unauthorized"
  end

  test "should pass on authenticated request" do
    # Create a test connection
    conn = conn(:get, "/api/me") |> init_test_session(%{
      current_user: Factory.make(:user, email: "test@mail.com")
    })

    # Invoke the plug
    conn = Router.call(conn, @opts)

    # Assert the header and conn state
    assert conn.status == 200
    assert conn.resp_body =~ "test@mail.com"
  end
end
