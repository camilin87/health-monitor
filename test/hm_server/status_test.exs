defmodule HMServer.StatusTest do
  use HMServerWeb.ConnCase

  alias HMServer.Status, as: Status
  alias HMServer.Repo, as: Repo

  describe "online?" do
    test "returns false when db is empty" do
      disable_api()

      assert false == Status.online?
    end

    test "returns false when the service is disabled" do
      disable_api()

      %Status{disabled: true}
      |> Repo.insert!

      assert false == Status.online?
    end

    test "returns true when the service is enabled" do
      disable_api()

      %Status{disabled: false}
      |> Repo.insert!

      assert true == Status.online?
    end

    test "caches the results for a short period of time" do
      assert true == Status.online?

      disable_api()

      assert true == Status.online?
    end
  end
end