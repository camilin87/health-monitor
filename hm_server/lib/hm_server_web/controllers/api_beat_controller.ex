defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  def create(conn, _params) do
    render conn, "success.json"
  end
end