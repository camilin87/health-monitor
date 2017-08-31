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
      nil ->
        %HMServer.Node {
          hostname: hostname,
          last_beat: DateTime.utc_now,
          credential: credential
        } |> HMServer.Repo.insert!
      %HMServer.Node{node_disabled: true} -> nil
      node ->
        updated_values = %{failure_count: 0, last_beat: DateTime.utc_now}
        updated_fields = [:failure_count, :last_beat]

        node
        |> Ecto.Changeset.cast(updated_values, updated_fields)
        |> HMServer.Repo.update!
    end

    json conn, %{success: true}
  end
  def create(conn, _), do: send_resp(conn, :bad_request, "")
end