defmodule HMServerWeb.ApiBeatControllerTest do
  use HMServerWeb.ConnCase

  test "POST /api/beat fails when no credentials are provided", %{conn: conn} do
    conn = post conn, "/api/beat"

    assert conn.status == 401
  end

  #
  # this test needs to be enhanced
  #
  # test "POST /api/beat", %{conn: conn} do
  #   conn = post conn, "/api/beat"

  #   assert json_response(conn, 200) == %{"success" => true}
  # end
end