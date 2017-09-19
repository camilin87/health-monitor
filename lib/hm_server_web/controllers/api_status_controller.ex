defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller

  def index(conn, _params), do: send_resp(conn, :ok, "")
end
