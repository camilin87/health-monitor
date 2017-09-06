defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller
  alias HMServer.Status, as: Status

  def index(conn, _params) do
    service_online = Status.online?
    service_status = case service_online do
      true -> :ok
      _ -> :service_unavailable
    end

    conn
      |> put_status(service_status)
      |> json(%{success: service_online, timestamp: DateTime.utc_now})
  end
end
