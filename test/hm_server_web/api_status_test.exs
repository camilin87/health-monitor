defmodule HMServerWeb.ApiStatusTest do
  use HMServerWeb.ConnCase
  alias HMServerWeb.ApiStatus, as: ApiStatus

  test "returns the connection when the api is online", %{conn: conn} do
    assert conn == ApiStatus.call(conn, %{})
  end

  test "returns service unavailable when the api is offline", %{conn: conn} do
    disable_api()

    conn = ApiStatus.call(conn, %{})

    assert 503 == conn.status
    assert true == conn.halted
  end
end