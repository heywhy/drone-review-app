defmodule ReviewAppWeb.Auth do
    @moduledoc """
    Retrieve the user information from an auth request
    """
    require Logger
    # require Poison

    alias Ueberauth.Auth
    alias ReviewApp.Models.User

    def find_or_create(%Auth{provider: :identity} = auth) do
      case validate_pass(auth.credentials) do
        :ok ->
          {:ok, basic_info(auth)}

        {:error, reason} ->
          {:error, reason}
      end
    end

    def find_or_create(%Auth{} = auth), do: basic_info(auth)

    # github does it this way
    defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

    # facebook does it this way
    defp avatar_from_auth(%{info: %{image: image}}), do: image

    # default case if nothing matches
    defp avatar_from_auth(auth) do
      Logger.warn("#{auth.provider} needs to find an avatar URL!")
      Logger.debug(Jason.encode!(auth))
      nil
    end

    defp basic_info(auth) do
      case ReviewApp.Repo.get_by(User, uid: to_string(auth.uid)) do
        nil -> create_user(auth)
        user -> {:ok, user}
      end
    end

    defp create_user(%Auth{} = auth) do
      %User{}
      |> User.changeset(get_user_info(auth))
      |> ReviewApp.Repo.insert()
      |> case do
        {:ok, user} -> {:ok, user}
        {:error, changeset} -> {:error, changeset}
      end
    end

    defp get_user_info(auth) do
      %{
        uid: to_string(auth.uid),
        name: name_from_auth(auth),
        email: email_from_auth(auth),
        username: username_from_auth(auth),
        avatar_url: avatar_from_auth(auth),
      }
    end

    defp email_from_auth(%{info: %{email: email}}), do: email

    defp username_from_auth(%Auth{info: info} = _auth), do: info.nickname

    defp name_from_auth(auth) do
      if auth.info.name do
        auth.info.name
      else
        name =
          [auth.info.first_name, auth.info.last_name]
          |> Enum.filter(&(&1 != nil and &1 != ""))

        if Enum.empty?(name) do
          auth.info.nickname
        else
          Enum.join(name, " ")
        end
      end
    end

    defp validate_pass(%{other: %{password: ""}}) do
      {:error, "Password required"}
    end

    defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
      :ok
    end

    defp validate_pass(%{other: %{password: _}}) do
      {:error, "Passwords do not match"}
    end

    defp validate_pass(_), do: {:error, "Password Required"}
  end
