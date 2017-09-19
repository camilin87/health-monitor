defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller

  plug HMServerWeb.ApiStatus when action in [:index]

  def index(conn, _params) do
    conn
    |> json(%{success: true, timestamp: DateTime.utc_now})
  end
end
