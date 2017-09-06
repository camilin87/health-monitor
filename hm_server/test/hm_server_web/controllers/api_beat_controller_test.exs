defmodule HMServerWeb.ApiBeatControllerTest do
  use HMServerWeb.ConnCase

  defp send_hostname(hostname \\ default_hostname()), do: [hostname: hostname] 

  defp validate_node!(params) do
    params = params |> Map.merge(%{
      hostname: default_hostname(),
      last_beat: DateTime.utc_now,
      failure_count: 0,
      disabled: false
    }, fn _, v1, _ -> v1 end)

    assert node = HMServer.Node |> HMServer.Repo.get_by!(hostname: params.hostname)
    assert params.hostname == node.hostname
    assert 0 == params.last_beat |> DateTime.diff(node.last_beat)
    assert params.failure_count == node.failure_count
    assert params.disabled == node.disabled
    assert params.credential_id == node.credential_id
  end

  setup do
    {:ok, _} = Cachex.clear(:api_cache)
    :ok
  end

  test "POST /api/beat fails when no credentials are provided", %{conn: conn} do
    conn = post conn, "/api/beat", send_hostname()

    assert conn.status == 401
  end

  test "POST /api/beat fails when no credentials are in the db", %{conn: conn} do
    conn = conn
    |> authenticate
    |> post("/api/beat", send_hostname())

    assert conn.status == 401
  end

  test "POST /api/beat fails when credentials are incorrect", %{conn: conn} do
    insert!(:credential)

    conn = conn
    |> authenticate(default_user(), "incorrect")
    |> post("/api/beat", send_hostname())

    assert conn.status == 401
  end

  test "POST /api/beat fails when credentials are disabled", %{conn: conn} do
    insert!(:credential, %{disabled: true})

    conn = conn
    |> authenticate
    |> post("/api/beat", send_hostname())

    assert conn.status == 401
  end

  test "POST /api/beat succeeds when credentials are correct", %{conn: conn} do
    insert!(:credential)

    conn = conn
    |> authenticate
    |> post("/api/beat", send_hostname())

    assert json_response(conn, 200) == %{"success" => true}
  end

  test "POST /api/beat fails when no hostname is specified", %{conn: conn} do
    insert!(:credential)

    conn = conn
    |> authenticate
    |> post("/api/beat")

    assert conn.status == 400
  end

  test "POST /api/beat inserts a node on the first beat", %{conn: conn} do
    insert!(:credential)
    cred = insert!(:credential, [client_id: "bbbbbbbb"])

    conn = conn
    |> authenticate("bbbbbbbb")
    |> post("/api/beat", send_hostname())

    assert json_response(conn, 200) == %{"success" => true}
    validate_node!(%{credential_id: cred.id})
  end

  test "POST /api/beat updates the node on consequent beats", %{conn: conn} do
    cred = insert!(:credential)
    {:ok, seeded_beat, 0} = DateTime.from_iso8601("2012-01-23T00:00:00Z")
    insert!(:node, [
      last_beat: seeded_beat,
      failure_count: 2,
      credential: cred
    ])

    conn = conn
    |> authenticate
    |> post("/api/beat", send_hostname())

    assert json_response(conn, 200) == %{"success" => true}
    validate_node!(%{credential_id: cred.id})
  end

  test "POST /api/beat does not update disabled nodes", %{conn: conn} do
    cred = insert!(:credential)
    insert!(:node, [
      disabled: true,
      failure_count: 2,
      credential: cred
    ])

    conn = conn
    |> authenticate
    |> post("/api/beat", send_hostname())

    assert json_response(conn, 200) == %{"success" => true}
    validate_node!(%{
      failure_count: 2,
      disabled: true,
      credential_id: cred.id
    })
  end
end