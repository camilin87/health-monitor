defmodule HMServerWeb.ApiStatus do
  @moduledoc """
  Plug.Conn to guarantee the api is online before accepting requests
  """

  import Plug.Conn
  alias HMServer.Status, as: Status

  def init(default), do: default

  def call(conn, _) do
    case Status.online? do
      false ->
        conn
        |> send_resp(:service_unavailable, "503 Service Unavailable")
        |> halt
      _ -> conn
    end
  end
end
