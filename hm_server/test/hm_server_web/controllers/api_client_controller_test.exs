defmodule HMServerWeb.ApiClientControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/clients empty db", %{conn: conn} do
    conn = get conn, "/api/clients"
    assert json_response(conn, 200) == []
  end

  test "GET /api/clients returns the credentials list", %{conn: conn} do
    insert!(:credential, %{client_id: "test0"})
    insert!(:credential, %{client_id: "test1", client_disabled: true})
    insert!(:credential, %{client_id: "test2"})

    conn = get conn, "/api/clients"

   assert json_response(conn, 200) == [
      %{"id" => "test0", "is_enabled" => true },
      %{"id" => "test1", "is_enabled" => false },
      %{"id" => "test2", "is_enabled" => true }
    ]
  end
end