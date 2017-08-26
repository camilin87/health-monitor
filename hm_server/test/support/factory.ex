defmodule HMServer.Factory do
  use ExMachina.Ecto, repo: HMServer.Repo

  def credential_factory do
    %HMServer.Credential {
      client_id: sequence("test"),
      secret_key: "111111",
      client_disabled: false
    }
  end
end