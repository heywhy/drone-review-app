defmodule ReviewApp.Encoders do
  alias Ueberauth.Auth.Credentials

  def auth_credential_keys, do: [
    :expires,
    :expires_at,
    :other,
    :refresh_token,
    :scopes,
    :secret,
    :token,
    :token_type
  ]

  defimpl Jason.Encoder, for: Credentials do
    alias ReviewApp.Encoders

    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, Encoders.auth_credential_keys()), opts)
    end
  end
end
