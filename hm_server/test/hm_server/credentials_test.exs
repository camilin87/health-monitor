defmodule HMServer.CredentialTest do
  use HMServerWeb.ConnCase

  import HMServer.Credential

  describe "is_valid" do
    test "false when incomplete credentials provided" do
      assert false == is_valid("", "")
      assert false == is_valid("", "secret")
      assert false == is_valid("user", "")
    end

    test "false when there are no credentials in the db" do
      assert false == is_valid("user", "pwd")
    end

    test "false when the credentials are incorrect" do
      insert!(:credential)

      assert false == is_valid("unknown", "unknown")
      assert false == is_valid(default_user(), "unknown")
      assert false == is_valid("unknown", default_password())
    end

    test "false when the credential is disabled" do
      insert!(:credential, %{disabled: true})

      assert false == is_valid(default_user(), default_password())
    end

    test "true when the credentials are correct" do
      insert!(:credential)

      assert true == is_valid(default_user(), default_password())
    end
  end
end