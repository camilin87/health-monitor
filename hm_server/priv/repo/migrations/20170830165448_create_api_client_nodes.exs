defmodule HMServer.Repo.Migrations.CreateApiClientNodes do
  use Ecto.Migration

  def change do
    create table(:api_client_nodes) do
      add :hostname, :string, size: 256, null: false
      add :last_beat, :utc_datetime, null: false
      add :failure_count, :integer, null: false, default: 0
      add :node_disabled, :boolean, default: false

      add :credential_id, references(:api_credentials), null: false

      timestamps()
    end

    create index(:api_client_nodes, [:hostname, :credential_id], unique: true)
  end
end
