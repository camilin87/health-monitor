defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller
  alias HMServer.Status, as: Status

  def index(conn, _params) do
    service_online = online?()

    service_status = case service_online do
      true -> :ok
      _ -> :service_unavailable
    end

    conn
      |> put_status(service_status)
      |> json(%{success: service_online, timestamp: DateTime.utc_now})
  end

  defp online? do
    case Cachex.get(:api_cache, "api_status_online") do
      {:ok, result} -> result
      _ ->
        result = Status.online?
        Cachex.set!(:api_cache, "api_status_online", result, [ ttl: :timer.seconds(5) ])
        result
    end
  end
end
