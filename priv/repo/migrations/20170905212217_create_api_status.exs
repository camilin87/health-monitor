defmodule HMServer.Repo.Migrations.CreateApiStatus do
  use Ecto.Migration
  alias HMServer.Repo, as: Repo
  alias HMServer.Status, as: Status

  def up do
    create table(:api_status) do
      add :disabled, :boolean, default: false

      timestamps()
    end

    flush()

    Repo.insert!(%Status{disabled: false})
  end

  def down do
    drop table(:api_status)
  end
end
