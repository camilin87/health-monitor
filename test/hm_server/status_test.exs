defmodule HMServer.StatusTest do
  use HMServerWeb.ConnCase

  alias HMServer.Status, as: Status
  alias HMServer.Repo, as: Repo

  describe "online?" do
    test "returns false when db is empty" do
      HMServer.Status
      |> Repo.delete_all

      assert false == Status.online?
    end

    test "returns false when the service is disabled" do
      HMServer.Status
      |> Repo.delete_all

      %HMServer.Status{disabled: true}
      |> Repo.insert!

      assert false == Status.online?
    end

    test "returns true when the service is enabled" do
      HMServer.Status
      |> Repo.delete_all

      %HMServer.Status{disabled: false}
      |> Repo.insert!

      assert true == Status.online?
    end

    test "caches the results for a short period of time" do
      assert true == Status.online?

      HMServer.Status
      |> Repo.delete_all

      assert true == Status.online?
    end
  end
end