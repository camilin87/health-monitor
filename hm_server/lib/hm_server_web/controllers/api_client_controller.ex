defmodule HMServerWeb.ApiClientController do
  use HMServerWeb, :controller

  def index(conn, _params) do
    credentials = HMServer.Repo.all(HMServer.Credential)
    json_result = Enum.map(credentials, &credential_json/1)

    json conn, json_result
  end

  defp credential_json(client) do
    %{
      id: client.client_id,
      is_enabled: !client.client_disabled
    }
  end
end