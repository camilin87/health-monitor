defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller

  def index(conn, _params) do
    json conn, %{success: true}
  end
end
