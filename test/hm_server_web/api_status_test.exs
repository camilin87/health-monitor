defmodule HMServerWeb.ApiStatusTest do
  use HMServerWeb.ConnCase
  alias HMServer.Repo, as: Repo

  test "returns the connection when the api is online", %{conn: conn} do
    assert conn == HMServerWeb.ApiStatus.call(conn, %{})
  end

  test "returns service unavailable when the api is offline", %{conn: conn} do
    HMServer.Status
    |> Repo.delete_all

    conn = HMServerWeb.ApiStatus.call(conn, %{})

    assert 503 == conn.status
    assert true == conn.halted
  end
end