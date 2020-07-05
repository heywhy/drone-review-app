defmodule ReviewApp.Models.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :uid, :string
      field :name, :string
      field :email, :string
      field :username, :string
      field :avatar_url, :string
      field :credentials, :map

      timestamps()
    end

    @doc false
    def changeset(user, attrs) do
      user
      |> cast(attrs, [:uid, :name, :email, :username, :avatar_url, :credentials])
      |> validate_required([:uid, :name, :username])
      |> update_change(:email, &String.downcase/1)
      |> update_change(:name, &String.downcase/1)
      |> unique_constraint(:email)
      |> unique_constraint(:username)
    end
  end
