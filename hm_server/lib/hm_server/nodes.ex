defmodule HMServer.Node do
  @moduledoc """
  Node: a single computing node that needs to be monitored
  """

  use Ecto.Schema
  alias Ecto.Changeset, as: Changeset
  alias HMServer.Repo, as: Repo

  schema "api_client_nodes" do
    field :hostname, :string
    field :last_beat, :utc_datetime
    field :failure_count, :integer
    field :node_disabled, :boolean

    belongs_to :credential, HMServer.Credential

    timestamps()
  end

  def update!(item) do
    case item.node_disabled do
      true -> item
      false ->
        changes = %{failure_count: 0, last_beat: DateTime.utc_now}
        fieldnames = [:failure_count, :last_beat]

        item
        |> Changeset.cast(changes, fieldnames)
        |> Repo.insert_or_update!
    end
  end
end
