defmodule HMServerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import HMServer.Factory
      import HMServerWeb.Router.Helpers
      import HMServerWeb.ConnCase

      # The default endpoint for testing
      @endpoint HMServerWeb.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HMServer.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(HMServer.Repo, {:shared, self()})
    end
    {:ok, _} = Cachex.clear(:api_cache)
    reset_user_rate_limit()
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  import HMServer.Factory
  import Plug.Conn

  def authenticate(conn, username \\ default_user(), password \\ default_password()) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  def datetimes_match(dt1, dt2) do
    DateTime.diff(dt1, dt2) <= 1
  end

  def reset_user_rate_limit(user \\ HMServer.Factory.default_user()) do
    bucket_id = HMServerWeb.Authentication.rate_limit_bucket_id(user)
    ExRated.delete_bucket(bucket_id)
  end
end
