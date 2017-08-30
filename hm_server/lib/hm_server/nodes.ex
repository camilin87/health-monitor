defmodule HMServer.Node do
  use Ecto.Schema

  schema "api_client_nodes" do
    field :hostname, :string
    field :last_beat, :utc_datetime
    field :failure_count, :integer
    field :node_disabled, :boolean

    belongs_to :credential, HMServer.Credential

    timestamps()
  end
end