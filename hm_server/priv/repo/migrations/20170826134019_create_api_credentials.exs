defmodule HMServer.Repo.Migrations.CreateApiCredentials do
  use Ecto.Migration

  def change do
    create table(:api_credentials) do
      add :client_id, :string, size: 256, null: false
      add :secret_key, :string, size: 256, null: false
      add :disabled, :boolean, default: false

      timestamps()
    end

    create index(:api_credentials, [:client_id], unique: true)
  end
end
