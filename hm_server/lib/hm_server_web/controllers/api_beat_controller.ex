defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [
    callback: &HMServerWeb.Authentication.authenticate/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    request_client_id = HMServerWeb.Authentication.read_user!(conn)
    credential = HMServer.Credential |> HMServer.Repo.get_by!(client_id: request_client_id)

    query = %{hostname: hostname, credential_id: credential.id}
    node = case HMServer.Node |> HMServer.Repo.get_by(query) do
      nil -> %HMServer.Node {hostname: hostname, credential: credential}
      %HMServer.Node{node_disabled: true} -> :skip
      existing_node -> existing_node
    end

    case node do
      :skip -> nil
      _ ->
        changes = %{failure_count: 0, last_beat: DateTime.utc_now}
        fieldnames = [:failure_count, :last_beat]

        node 
        |> Ecto.Changeset.cast(changes, fieldnames)
        |> HMServer.Repo.insert_or_update!
    end

    json conn, %{success: true}
  end
  def create(conn, _), do: send_resp(conn, :bad_request, "")
end