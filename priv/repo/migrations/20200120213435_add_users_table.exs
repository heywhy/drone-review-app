defmodule ReviewApp.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do

      add :uid, :string, [null: false]
      add :name, :string, [null: false]
      add :email, :string, [null: true]
      add :username, :string, [null: false]
      add :avatar_url, :string, [null: true]

      timestamps()
    end

    create unique_index(:users, :uid)
    create unique_index(:users, :username)
  end
end
