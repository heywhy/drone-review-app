defmodule ReviewApp.Models.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias ReviewApp.Models.User

  @derive {Jason.Encoder, except: [:__meta__, :activator]}
  @attrs [:node_id, :full_name, :private, :html_url, :url, :events_url, :pulls_url, :ssh_url]

  schema "repositories" do
    field :node_id, :string
    field :full_name, :string
    field :activated, :boolean
    field :private, :boolean
    field :html_url, :string
    field :url, :string
    field :events_url, :string
    field :pulls_url, :string
    field :ssh_url, :string

    belongs_to :activator, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint(@attrs)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required([:id | @attrs])
    |> unique_constraint(@attrs)
  end
end
