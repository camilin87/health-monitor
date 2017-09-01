defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller
  alias HMServer.Repo, as: Repo
  alias HMServerWeb.Authentication, as: Authentication

  plug BasicAuth, [
    callback: &Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = Authentication.read_user!(conn)
    credential = HMServer.Credential
    |> Repo.get_by!(client_id: request_client_id)

    query = %{hostname: hostname, credential_id: credential.id}
    target_node = case HMServer.Node |> Repo.get_by(query) do
      nil -> %HMServer.Node{
        hostname: hostname,
        credential: credential,
        node_disabled: false
      }
      existing_node -> existing_node
    end
    target_node |> HMServer.Node.update!

    json conn, %{success: true}
  end

  def create(conn, _), do: send_resp(conn, :bad_request, "")
end
