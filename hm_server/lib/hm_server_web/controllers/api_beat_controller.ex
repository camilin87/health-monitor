defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  def create(conn, _params) do
    # json conn, %{success: true}

    send_resp(conn, :unauthorized, "")
  end
end