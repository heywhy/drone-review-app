defmodule ReviewApp.Encoders do
  alias Paginator.Page
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

  def paginator_keys, do: [:metadata, :entries]

  defimpl Jason.Encoder, for: Credentials do
    alias ReviewApp.Encoders

    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, Encoders.auth_credential_keys()), opts)
    end
  end

  defimpl Jason.Encoder, for: Page do
    alias ReviewApp.Encoders

    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, Encoders.paginator_keys()), opts)
    end
  end

  defimpl Jason.Encoder, for: Page.Metadata do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:after, :before, :limit, :total_count, :total_count_cap_exceeded]), opts)
    end
  end
end
