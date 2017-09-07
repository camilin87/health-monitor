defmodule HMServerWeb.Authentication do
  @moduledoc """
  Encapsulates authentication-related functionality such as
  - Reading the authenticated user
  - Authenticating a web request
  """

  import Plug.Conn
  alias HMServer.Credential, as: Credential

  def read_credential!(conn) do
    conn
    |> read_user!
    |> Credential.get_by!
  end

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
    case is_valid(user, secret) do
      false -> conn |> halt
      _ -> conn
    end
  end

  defp is_valid(user, secret) do
    check_rate_limit(user) && Credential.is_valid(user, secret)
  end

  defp check_rate_limit(user) do
    !rate_limit_exceeded?(user)
  end

  def rate_limit_bucket_id(user) do
    "HMServer.Authentication.authenticate.#{user}"
  end

  defp rate_limit_exceeded?(user) do
    key = rate_limit_bucket_id(user)
    case ExRated.check_rate(key, 5_000, 5) do
      {:ok, _} -> false
      _ -> true
    end
  end
end
