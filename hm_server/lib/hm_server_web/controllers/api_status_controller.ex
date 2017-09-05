defmodule HMServerWeb.ApiStatusController do
  use HMServerWeb, :controller
  alias HMServer.Repo, as: Repo

  def index(conn, _params) do
    json conn, %{success: true}
  end
end