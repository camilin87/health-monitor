defmodule HMServerWeb.ApiBeatControllerTest do
  use HMServerWeb.ConnCase

  test "POST /api/beat", %{conn: conn} do
    conn = post conn, "/api/beat"

    assert json_response(conn, 200) == %{"success" => true}
  end
end