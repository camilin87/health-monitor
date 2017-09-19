defmodule HMServerWeb.ApiStatusControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/status returns ok", %{conn: conn} do
    assert 200 == get(conn, "/api/status").status
  end

  test "GET /api/status returns not ok the db is not online", %{conn: conn} do
    disable_api()

    assert 503 == get(conn, "/api/status").status
  end

  test "GET /api/status caches responses for a short period of time", %{conn: conn} do
    assert 200 == get(conn, "/api/status").status

    disable_api()

    assert 200 == get(conn, "/api/status").status
  end
end
