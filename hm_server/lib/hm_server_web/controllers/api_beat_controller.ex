defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [
    callback: &HMServerWeb.ApiBeatController.validate_credentials/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = HMServerWeb.Authorization.read_user!(conn)
    credential = HMServer.Credential |> HMServer.Repo.get_by!(client_id: request_client_id)

    %HMServer.Node {
      hostname: hostname,
      last_beat: DateTime.utc_now,
      credential: credential
    } |> HMServer.Repo.insert!

    json conn, %{success: true}
  end
  def create(conn, _), do: send_resp(conn, :bad_request, "")

  def validate_credentials(conn, "", _), do: conn |> halt
  def validate_credentials(conn, _, ""), do: conn |> halt
  def validate_credentials(conn, user, password) do
    query = %{client_id: user, secret_key: password, client_disabled: false}

    case HMServer.Repo.get_by(HMServer.Credential, query) do
      %HMServer.Credential{} -> conn
      _ -> conn |> halt
    end
  end
end