defmodule HMServerWeb.ApiBeatController do
  use HMServerWeb, :controller

  plug BasicAuth, [callback: &HMServerWeb.ApiBeatController.validate_credentials/3] when action in [:create]

  def create(conn, _params) do
    json conn, %{success: true}
  end

  def validate_credentials(conn, user, password) do
    # IO.inspect ["validate_credentials", user, password]

    query = %{client_id: user, secret_key: password, client_disabled: false}

    case HMServer.Repo.get_by(HMServer.Credential, query) do
      %HMServer.Credential{} -> conn
      _ -> conn |> halt
    end

  end
end