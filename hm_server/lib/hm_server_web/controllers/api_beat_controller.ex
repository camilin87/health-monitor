defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [
    callback: &HMServerWeb.Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = HMServerWeb.Authentication.read_user!(conn)
    credential = HMServer.Credential |> HMServer.Repo.get_by!(client_id: request_client_id)

    query = %{hostname: hostname, credential_id: credential.id}
    case HMServer.Node |> HMServer.Repo.get_by(query) do
      nil -> %HMServer.Node {hostname: hostname, credential: credential, node_disabled: false}
      existing_node -> existing_node
    end
    |> HMServer.Node.update!

    json conn, %{success: true}
  end

  def create(conn, _), do: send_resp(conn, :bad_request, "")
end