defmodule HMServer.CredentialTest do
  use HMServerWeb.ConnCase

  import HMServer.Credential

  setup do
    {:ok, _} = Cachex.clear(:api_cache)
    :ok
  end

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

    test "caches the result for a short period of time" do
      assert false == is_valid(default_user(), default_password())

      insert!(:credential)

      assert false == is_valid(default_user(), default_password())
    end

    test "cache is user and secret specific" do
      assert false == is_valid(default_user(), default_password())

      insert!(:credential)
      insert!(:credential, %{client_id: "aaaaaaa"})

      assert false == is_valid(default_user(), default_password())
      assert true == is_valid("aaaaaaa", default_password())
      assert false == is_valid("aaaaaaa", "incorrect")
    end
  end

  describe "get_by!" do
    test "returns the credential with the specified client_id" do
      seeded_cred = insert!(:credential)

      assert cred = get_by!(default_user())

      assert seeded_cred.id == cred.id
      assert seeded_cred.client_id == cred.client_id
    end

    test "fails when the credential is not found" do
      assert_raise Ecto.NoResultsError, fn ->
        get_by!(default_user())
      end
    end
  end
end