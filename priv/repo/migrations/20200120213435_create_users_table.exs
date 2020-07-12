defmodule ReviewApp.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users) do

      add :uid, :string, [null: false]
      add :name, :string, [null: false]
      add :email, :string, [null: true]
      add :username, :string, [null: false]
      add :avatar_url, :string, [null: true]
      add :credentials, :map, [null: true]

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, :uid)
    create unique_index(:users, :username)
  end


  def down do
    drop table(:users)
  end
end
