defmodule HMServer.Status do
  @moduledoc """
  Status: the overall service status
  """

  use Ecto.Schema
  alias HMServer.Repo, as: Repo

  schema "api_status" do
    field :disabled, :boolean

    timestamps()
  end

  def online? do
    case HMServer.Status |> Repo.one do
      nil -> false
      %HMServer.Status{disabled: true} -> false
      _ -> true
    end
  end
end
