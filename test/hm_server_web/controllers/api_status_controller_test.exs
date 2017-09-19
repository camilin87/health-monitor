defmodule HMServerWeb.ApiStatusControllerTest do
  use HMServerWeb.ConnCase
  alias HMServer.Repo, as: Repo

  test "GET /api/status returns ok", %{conn: conn} do
    assert 200 == get(conn, "/api/status").status
  end

  test "GET /api/status returns not ok the db is not online", %{conn: conn} do
    HMServer.Status
    |> Repo.delete_all

    assert 503 == get(conn, "/api/status").status
  end

  test "GET /api/status caches responses for a short period of time", %{conn: conn} do
    assert 200 == get(conn, "/api/status").status

    HMServer.Status
    |> Repo.delete_all

    assert 200 == get(conn, "/api/status").status
  end
end
