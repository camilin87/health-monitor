defmodule HMServerWeb.ApiClientView do
  use HMServerWeb, :view

  def render("index.json", %{credentials: credentials}) do
    Enum.map(credentials, &credential_json/1)
  end

  def credential_json(client) do
    %{
      id: client.client_id,
      is_enabled: !client.client_disabled
    }
  end
end