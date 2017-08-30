defmodule HMServerWeb.AuthorizationTest do
  use HMServerWeb.ConnCase

  describe "read_user" do
    test "reads the user", %{conn: conn} do
      assert {:ok, default_user()} == conn |> authenticate |> HMServerWeb.Authorization.read_user
    end

    test "doesn't read the user when it is empty", %{conn: conn} do
      assert :error == conn |> authenticate("") |> HMServerWeb.Authorization.read_user
    end

    test "doesn't read the user when no authorization header is provided", %{conn: conn} do
      assert :error == conn |> HMServerWeb.Authorization.read_user
    end

    test "doesn't read the user when authorization is not basic", %{conn: conn} do
      assert :error == conn |> put_req_header("authorization", "invalid") |> HMServerWeb.Authorization.read_user
    end

    test "doesn't read the user when header value is invalid", %{conn: conn} do
      assert :error == conn |> put_req_header("authorization", "Basic invalid") |> HMServerWeb.Authorization.read_user
    end
  end

  describe "read_user!" do
    test "reads the user", %{conn: conn} do
      assert default_user() == conn |> authenticate |> HMServerWeb.Authorization.read_user!
    end

    test "fails when the user is empty", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        assert default_user() == conn |> authenticate("") |> HMServerWeb.Authorization.read_user!
      end
    end

    test "fails when no authorization header is provided", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> HMServerWeb.Authorization.read_user!
      end
    end

    test "fails when authorization is not basic", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> put_req_header("authorization", "invalid") |> HMServerWeb.Authorization.read_user!
      end
    end

    test "fails when header value is invalid", %{conn: conn} do
      assert_raise ArgumentError, fn ->
        conn |> put_req_header("authorization", "Basic invalid") |> HMServerWeb.Authorization.read_user!
      end
    end
  end
end