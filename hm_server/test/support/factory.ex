defmodule HMServer.Factory do
  def default_user, do: "test"
  def default_password, do: "111111"

  def build(:credential) do
    %HMServer.Credential {
      client_id: default_user(),
      secret_key: default_password(),
      client_disabled: false
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    HMServer.Repo.insert! build(factory_name, attributes)
  end

  def attrs_map(factory_name, attributes\\[]) do
    build(factory_name, attributes)
    |> Map.from_struct
  end
end
