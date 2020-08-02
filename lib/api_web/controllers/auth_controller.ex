defmodule ReviewAppWeb.AuthController do
  use ReviewAppWeb, :controller

  alias ReviewAppWeb.Auth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Auth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> Auth.set_current_user(user)
        |> configure_session(renew: true)
        |> authenticated()

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def me(%Plug.Conn{} = conn, _params) do
    conn |> json(Auth.current_user(conn))
  end

  defp authenticated(conn) do
    config = Application.get_env(:review_app, ReviewApp)

    if Keyword.has_key?(config, :env) && config[:env] == :dev do
      redirect(conn, external: config[:ui_url])
    else
      redirect(conn, to: "/")
    end
  end
end
