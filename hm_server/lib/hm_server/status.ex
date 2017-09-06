defmodule HMServer.Status do
  @moduledoc """
  Status: the overall service status
  """

  use Ecto.Schema
  require Logger
  alias HMServer.Repo, as: Repo

  schema "api_status" do
    field :disabled, :boolean

    timestamps()
  end

  def online? do
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
