defmodule HMServerWeb.AuthorizationTest do
  use HMServerWeb.ConnCase

  describe "read_user" do
    test "reads the user", %{conn: conn} do
      assert default_user() == conn |> authenticate |> HMServerWeb.Authorization.read_user
    end
  end
end