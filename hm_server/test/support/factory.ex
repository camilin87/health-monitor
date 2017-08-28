defmodule HMServer.Factory do
  def build(:credential) do
    %HMServer.Credential {
      client_id: "test",
      secret_key: "111111",
      client_disabled: false
    }
  end

  # Convenience API
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
