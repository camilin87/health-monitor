defmodule HMServer.Credential do
  use Ecto.Schema

  schema "api_credentials" do
    field :client_id, :string
    field :secret_key, :string
    field :client_disabled, :boolean

    timestamps()
  end
end