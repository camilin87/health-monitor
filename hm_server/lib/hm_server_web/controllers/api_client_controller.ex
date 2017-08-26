defmodule HMServerWeb.ApiClientController do
  use HMServerWeb, :controller

  def index(conn, _params) do
    credentials = HMServer.Repo.all(HMServer.Credential)
    render conn, "index.json", credentials: credentials
  end
end