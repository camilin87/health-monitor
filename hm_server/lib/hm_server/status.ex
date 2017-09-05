defmodule HMServer.Status do
  @moduledoc """
  Status: the overall service status
  """

  use Ecto.Schema

  schema "api_status" do
    field :disabled, :boolean

    timestamps()
  end
end
