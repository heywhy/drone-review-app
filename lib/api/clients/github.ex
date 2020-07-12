defmodule ReviewApp.Clients.Github do
  alias ReviewApp.Models.User

  def initiate_client(%User{credentials: %{"token" => token}}), do:
    Tentacat.Client.new(%{jwt: token})
end
