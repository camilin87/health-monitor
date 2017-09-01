defmodule HMServerWeb.ApiClientController do
  use HMServerWeb, :controller
  alias HMServer.Repo, as: Repo

  def index(conn, _params) do
    json_result = HMServer.Credential
    |> Repo.all
    |> Enum.map(&credential_json/1)

    json conn, json_result
  end

  defp credential_json(client) do
    %{
      id: client.client_id,
      is_enabled: !client.client_disabled
    }
  end
end
