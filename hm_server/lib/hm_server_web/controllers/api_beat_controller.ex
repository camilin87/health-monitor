defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller
  alias HMServer.Repo, as: Repo
  alias HMServerWeb.Authentication, as: Authentication

  plug BasicAuth, [
    callback: &Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = conn
    |> Authentication.read_user!

    credential = HMServer.Credential
    |> Repo.get_by!(client_id: request_client_id)

    HMServer.Node.get_by!(hostname, credential)
    |> HMServer.Node.update!

    json conn, %{success: true}
  end

  def create(conn, _), do: send_resp(conn, :bad_request, "")
end
