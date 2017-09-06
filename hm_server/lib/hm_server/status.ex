defmodule HMServer.Status do
  @moduledoc """
  Status: the overall service status
  """

  use Ecto.Schema
  require Logger
  alias HMServer.Repo, as: Repo
  alias HMServer.Cache, as: Cache

  schema "api_status" do
    field :disabled, :boolean

    timestamps()
  end

  def online? do
    Cache.get_or_store("HMServer.Status.online?", &read_db_status/0)
  end

  defp read_db_status do
    case HMServer.Status |> Repo.one do
      nil ->
        Logger.info "HMServer.Status.online? - Api is disabled; result=false;"
        false
      %HMServer.Status{disabled: true} ->
        Logger.info "HMServer.Status.online? - Api is manually disabled; result=true;"
        false
      _ -> true
    end
  end
end
