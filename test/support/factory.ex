defmodule HMServer.Factory do
  alias HMServer.Repo, as: Repo

  def default_user, do: "test"
  def default_password, do: "111111"
  def default_hostname, do: "node1"

  def build(:credential) do
    %HMServer.Credential{
      client_id: default_user(),
      secret_key: default_password(),
      disabled: false
    }
  end

  def build(:node) do
    %HMServer.Node{
      hostname: default_hostname(),
      last_beat: DateTime.utc_now,
      failure_count: 0,
      disabled: false
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end

  def attrs_map(factory_name, attributes\\[]) do
    build(factory_name, attributes)
    |> Map.from_struct
  end
end
