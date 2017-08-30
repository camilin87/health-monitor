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
end