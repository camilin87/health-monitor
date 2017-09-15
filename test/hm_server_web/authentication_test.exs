defmodule HMServerWeb.AuthenticationTest do
  use HMServerWeb.ConnCase

  test "targeted failure" do
    assert 2 == 1
  end

  describe "read_user!" do
    test "reads the user", %{conn: conn} do
      assert default_user() == conn
      |> authenticate
      |> HMServerWeb.Authentication.read_user!
    end

    test "fails when the user is empty", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        assert default_user() == conn
        |> authenticate("")
        |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when no authorization header is provided", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when authorization is not basic", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn
        |> put_req_header("authorization", "invalid")
        |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when header value is invalid", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn
        |> put_req_header("authorization", "Basic invalid")
        |> HMServerWeb.Authentication.read_user!
      end
    end
  end

  describe "read_credential!" do
    test "reads the credential", %{conn: conn} do
      seeded_cred = insert!(:credential)

      assert cred = conn
      |> authenticate
      |> HMServerWeb.Authentication.read_credential!

      assert seeded_cred.id == cred.id
      assert seeded_cred.client_id == cred.client_id
    end
  end

  describe "authenticate" do
    test "halts the connection when credentials are invalid", %{conn: conn} do
      assert true == HMServerWeb.Authentication.authenticate(conn, "unknown", "unknown").halted
    end

    test "returns the connection unmodified when the credentials are valid", %{conn: conn} do
      insert!(:credential)
      assert conn == HMServerWeb.Authentication.authenticate(conn, default_user(), default_password())
    end

    test "rate limits the credential", %{conn: conn} do
      reset_user_rate_limit("AAAAAA")
      reset_user_rate_limit("BBBBBB")
      insert!(:credential, %{client_id: "AAAAAA"})
      insert!(:credential, %{client_id: "BBBBBB"})

      1..5
      |> Enum.to_list
      |> Enum.each(fn _ ->
        assert false == HMServerWeb.Authentication.authenticate(conn, "AAAAAA", default_password()).halted
      end)
      assert true == HMServerWeb.Authentication.authenticate(conn, "AAAAAA", default_password()).halted

      1..5
      |> Enum.to_list
      |> Enum.each(fn _ ->
        assert false == HMServerWeb.Authentication.authenticate(conn, "BBBBBB", default_password()).halted
      end)
    end
  end
end