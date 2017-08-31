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
end