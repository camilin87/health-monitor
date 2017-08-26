defmodule HMServerWeb.ApiClientControllerTest do
  use HMServerWeb.ConnCase

  test "GET /api/clients empty db", %{conn: conn} do
    conn = get conn, "/api/clients"
    assert json_response(conn, 200) == []
  end

  test "GET /api/clients returns the credentials list", %{conn: conn} do
    seeded_credentials = [
      insert(:credential),
      insert(:credential, %{client_disabled: true}),
      insert(:credential)
    ]

    conn = get conn, "/api/clients"

    assert json_response(conn, 200) == render_json(credentials: [
      %{client_id: "test0", client_disabled: false},
      %{client_id: "test1", client_disabled: true},
      %{client_id: "test2", client_disabled: false},
    ])
  end

  defp render_json(data, view_name \\ "index.json") do
    data = Map.new(data)

    HMServerWeb.ApiClientView.render(view_name, data)
    |> Poison.encode!
    |> Poison.decode!
  end
end