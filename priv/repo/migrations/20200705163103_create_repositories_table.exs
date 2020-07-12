defmodule ReviewApp.Repo.Migrations.CreateRepositoriesTable do
  use Ecto.Migration

  def up do
    create table(:repositories) do
      add :node_id, :string, null: false
      add :full_name, :string, size: 100, null: false
      add :activated, :boolean, default: false
      add :private, :boolean, default: false
      add :html_url, :string, size: 150, null: false
      add :url, :string, size: 150, null: false
      add :events_url, :string, size: 150, null: false
      add :pulls_url, :string, size: 150, null: false
      add :ssh_url, :string, size: 150, null: false
      add :activator_id, :integer, null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:repositories, [:node_id, :full_name, :html_url, :ssh_url], name: :attrs_index)
  end

  def down do
    drop table(:repositories)
  end
end
