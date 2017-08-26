defmodule HMServerWeb.ApiClientControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/clients empty db", %{conn: conn} do
    conn = get conn, "/api/clients"
    assert json_response(conn, 200) == []
  end

  test "GET /api/clients", %{conn: conn} do
    seeded_credentials = [
      insert(:credential),
      insert(:credential, %{client_disabled: true}),
      insert(:credential)
    ]

    conn = get conn, "/api/clients"

    assert json_response(conn, 200) == [
      %{"id" => Enum.at(seeded_credentials, 0).client_id, "is_enabled" => true },
      %{"id" => Enum.at(seeded_credentials, 1).client_id, "is_enabled" => false },
      %{"id" => Enum.at(seeded_credentials, 2).client_id, "is_enabled" => true }
    ]
  end
end