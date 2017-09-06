defmodule HMServer.Credential do
  @moduledoc """
  Credential: a single registered api account
  """

  use Ecto.Schema
  require Logger
  alias HMServer.Repo, as: Repo
  alias HMServer.Cache, as: Cache

  schema "api_credentials" do
    field :client_id, :string
    field :secret_key, :string
    field :disabled, :boolean

    timestamps()
  end

  def is_valid("", ""), do: false
  def is_valid("", _), do: false
  def is_valid(_, ""), do: false
  def is_valid(user, secret) do
    store_func = fn ->
      read_db_is_valid(user, secret)
    end
    key = is_valid_cache_key(user, secret)
    Cache.get_or_store(key, store_func)
  end

  defp is_valid_cache_key(user, secret) do
    suffix = Base.encode64("#{user}:#{secret}")
    "HMServer.Credential.is_valid.#{suffix}"
  end

  defp read_db_is_valid(user, secret) do
    query = %{client_id: user, secret_key: secret}

    case HMServer.Credential |> Repo.get_by(query) do
      nil -> false
      credential -> credential |> is_valid_credential
    end
  end

  defp is_valid_credential(credential) do
    case credential.disabled do
      true ->
        Logger.info "HMServer.Credential.is_valid_credential - Received disabled credential; credential_id=#{credential.id}; result=false;"
        false
      _ ->
        Logger.info "HMServer.Credential.is_valid_credential - Found valid credential; credential_id=#{credential.id}; result=true;"
        true
    end
  end

  def get_by!(client_id) do
    HMServer.Credential
    |> Repo.get_by!(client_id: client_id)
  end
end
