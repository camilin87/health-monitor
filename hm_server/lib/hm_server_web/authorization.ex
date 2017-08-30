defmodule HMServerWeb.Authorization do
  import Plug.Conn

  def read_user(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> encoded_header] ->
        case Base.decode64(encoded_header) do
          {:ok, decoded_header} ->
              case String.split(decoded_header, ":") do
                ["", _] -> :error
                [user, _] -> {:ok, user}
                _ -> :error
              end
          _ -> :error
        end
      _ -> :error
    end
  end

  def read_user!(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> encoded_kvp] ->
          case encoded_kvp |> Base.decode64! |> String.split(":") do
            ["", _] -> raise ArgumentError, "The `authorization` header contains an empty user."
            [user, _] -> user
            _ -> raise ArgumentError, "The `authorization` header does not contain a valid user."
          end
      _ -> raise ArgumentError, "The `authorization` header in the request is missing or it has an incorrect value."
    end
  end
end