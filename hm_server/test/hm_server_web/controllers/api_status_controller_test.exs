defmodule HMServerWeb.ApiStatusControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/status returns ok", %{conn: conn} do
    conn = get conn, "/api/status"
    assert true == json_response(conn, 200)["success"]
  end
end