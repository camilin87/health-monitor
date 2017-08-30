defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [
    callback: &HMServerWeb.ApiBeatController.validate_credentials/3
  ] when action in [:create]

  def create(conn, %{"hostname" => hostname}) do
    # HMServer.Credential |> HMServer.Repo.all |> IO.inspect
    # IO.puts "-------"

    header_content = Plug.Conn.get_req_header(conn, "authorization")
    ["Basic " <> encoded_string] = header_content
    decoded_string = encoded_string |> Base.decode64! |> String.split(":")
    [client_id, _] = decoded_string
    # IO.inspect client_id
    # IO.puts "-------"

    cred = HMServer.Credential |> HMServer.Repo.get_by!(client_id: client_id)
    # IO.inspect cred

    %HMServer.Node {
      hostname: hostname,
      last_beat: DateTime.utc_now,
      credential: cred
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