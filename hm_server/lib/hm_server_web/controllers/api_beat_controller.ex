defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [
    callback: &HMServerWeb.Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = HMServerWeb.Authentication.read_user!(conn)
    credential = HMServer.Credential |> HMServer.Repo.get_by!(client_id: request_client_id)

    %HMServer.Node {
      hostname: hostname,
      last_beat: DateTime.utc_now,
      credential: credential
    } |> HMServer.Repo.insert!

    json conn, %{success: true}
  end
  def create(conn, _), do: send_resp(conn, :bad_request, "")
end