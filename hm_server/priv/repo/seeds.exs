# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HMServer.Repo.insert!(%HMServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SeedHelper do
  def get_credential(name), do: HMServer.Repo.get_by(HMServer.Credential, client_id: name)

  def insert(), do: &HMServer.Repo.insert!(&1)

  def update_last_beat(), do: &SeedHelper.update_last_beat(&1)
  def update_last_beat(item), do: item |> Map.put(:last_beat, DateTime.utc_now)
end


# idempotency guarantor
HMServer.Node |> HMServer.Repo.delete_all
HMServer.Credential |> HMServer.Repo.delete_all


[
  %HMServer.Credential{client_id: "test", secret_key: "111111"},
  %HMServer.Credential{client_id: "sample", secret_key: "aaaaa"},
  %HMServer.Credential{client_id: "invalid", secret_key: "111111", client_disabled: true}
]
|> Enum.each(SeedHelper.insert)


[
  %HMServer.Node{hostname: "node1", credential: SeedHelper.get_credential("test")},
  %HMServer.Node{hostname: "node2", credential: SeedHelper.get_credential("test")},
  %HMServer.Node{hostname: "node1", credential: SeedHelper.get_credential("sample")},
  %HMServer.Node{hostname: "node2", credential: SeedHelper.get_credential("sample")}
]
|> Enum.map(SeedHelper.update_last_beat)
|> Enum.each(SeedHelper.insert)