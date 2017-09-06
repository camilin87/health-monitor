defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller

  def index(conn, _params) do
    json conn, %{success: true, timestamp: DateTime.utc_now}
  end
end
