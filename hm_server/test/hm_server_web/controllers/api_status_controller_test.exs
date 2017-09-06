defmodule HMServerWeb.ApiStatusControllerTest do
  use HMServerWeb.ConnCase
  alias HMServer.Repo, as: Repo

  setup do
    clear_cache()
  end

  test "GET /api/status returns ok", %{conn: conn} do
    conn = get conn, "/api/status"

    assert true == json_response(conn, 200)["success"]
  end

  test "GET /api/status returns not ok the db is not online", %{conn: conn} do
    HMServer.Status
    |> Repo.delete_all

    conn = get conn, "/api/status"

    assert false == json_response(conn, 503)["success"]
  end

  test "GET /api/status caches responses for a short period of time", %{conn: conn} do
    conn = get conn, "/api/status"
    assert true == json_response(conn, 200)["success"]

    HMServer.Status
    |> Repo.delete_all

    conn = get conn, "/api/status"
    assert true == json_response(conn, 200)["success"]
  end
end
