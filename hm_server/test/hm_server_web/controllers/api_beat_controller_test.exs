defmodule HMServerWeb.ApiBeatControllerTest do
  use HMServerWeb.ConnCase

  test "POST /api/beat fails when no credentials are provided", %{conn: conn} do
    conn = post conn, "/api/beat"

    assert conn.status == 401
  end

  test "POST /api/beat fails when no credentials are in the db", %{conn: conn} do
    conn = conn
    |> authenticate("test", "111111")
    |> post("/api/beat")

    assert conn.status == 401
  end

  #
  # this test needs to be enhanced
  #
  # test "POST /api/beat", %{conn: conn} do
  #   conn = post conn, "/api/beat"

  #   assert json_response(conn, 200) == %{"success" => true}
  # end

  defp authenticate(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end
end