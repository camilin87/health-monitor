defmodule HMServer.Repo.Migrations.CreateApiStatus do
  use Ecto.Migration
  alias HMServer.Repo, as: Repo

  def up do
    create table(:api_status) do
      add :disabled, :boolean, default: false

      timestamps()
    end

    flush()

    Repo.insert!(%HMServer.Status{disabled: false})
  end

  def down do
    drop table(:api_status)
  end
end
