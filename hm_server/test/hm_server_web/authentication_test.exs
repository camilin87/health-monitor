defmodule HMServerWeb.AuthenticationTest do
  use HMServerWeb.ConnCase

  describe "read_user!" do
    test "reads the user", %{conn: conn} do
      assert default_user() == conn |> authenticate |> HMServerWeb.Authentication.read_user!
    end

    test "fails when the user is empty", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        assert default_user() == conn |> authenticate("") |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when no authorization header is provided", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when authorization is not basic", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> put_req_header("authorization", "invalid") |> HMServerWeb.Authentication.read_user!
      end
    end

    test "fails when header value is invalid", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> put_req_header("authorization", "Basic invalid") |> HMServerWeb.Authentication.read_user!
      end
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
  end
end