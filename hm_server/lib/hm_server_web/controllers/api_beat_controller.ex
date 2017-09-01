defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller
  alias HMServer.Repo, as: Repo
  alias HMServerWeb.Authentication, as: Authentication

  plug BasicAuth, [
    callback: &Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    client_id = conn |> Authentication.read_user!

    credential = HMServer.Credential
    |> Repo.get_by!(client_id: client_id)

    node = HMServer.Node.get_by!(hostname, credential)

    node |> HMServer.Node.update!

    json conn, %{success: true}
  end

  def create(conn, _), do: send_resp(conn, :bad_request, "")
end
