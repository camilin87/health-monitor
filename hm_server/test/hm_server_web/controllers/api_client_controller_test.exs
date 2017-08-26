defmodule HMServerWeb.ApiClientControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/clients empty db", %{conn: conn} do
    conn = get conn, "/api/clients"
    assert json_response(conn, 200) == []
  end

  # test "GET /api/clients" do
  #   conn = build_conn()
  #   credential = insert(:credential)

  #   # c = build(:credential)
  #   # IO.inspect c

  #   # conn = get conn, api_client_path(conn, :index)

  #   # assert json_response(conn, 200) == []
  # end

  test "GET /api/clients renders a list of credentials", %{conn: conn} do
    credential = insert(:credential)

    # conn = get conn, api_client_path(conn, :index)

    # assert json_response(conn, 200) == []
  end
end