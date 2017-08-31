defmodule HMServerWeb.Authentication do
  @moduledoc """
  Encapsulates authentication-related functionality such as
  - Reading the authenticated user
  - Authenticating a web request
  """

  import Plug.Conn

  def read_user!(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> encoded_kvp] -> decode_user(encoded_kvp)
      _ -> raise ArgumentError, "The `authorization` header in the request is missing or it has an incorrect value."
    end
  end

  defp decode_user(encoded_kvp) do
    case encoded_kvp |> Base.decode64! |> String.split(":") do
      ["", _] -> raise ArgumentError, "The `authorization` header contains an empty user."
      [user, _] -> user
      _ -> raise ArgumentError, "The `authorization` header does not contain a valid user."
    end
  end

  def authenticate(conn, user, secret) do
    case HMServer.Credential.is_valid(user, secret) do
      true -> conn
      _ -> conn |> halt
    end
  end
end