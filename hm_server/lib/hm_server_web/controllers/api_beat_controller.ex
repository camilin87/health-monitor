defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  def create(conn, _params) do
    # json conn, %{success: true}

    # IO.inspect conn.req_headers.authorization

    send_resp(conn, :unauthorized, "")
  end
end