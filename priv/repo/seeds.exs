# Script for populating the database. You can run it as:
#
#     mix seed
#

alias HMServer.Repo, as: Repo
alias HMServer.Credential, as: Credential
alias HMServer.Node, as: Node

defmodule SeedHelper do
  def get_credential(name), do: Repo.get_by(Credential, client_id: name)

  def insert(), do: &Repo.insert!(&1)

  def delete_all(), do: &Repo.delete_all(&1)

  def update_last_beat(), do: &SeedHelper.update_last_beat(&1)
  def update_last_beat(item), do: %{item | last_beat: DateTime.utc_now}
end


# idempotency guarantor
[
  Node,
  Credential
]
|> Enum.each(SeedHelper.delete_all)


[
  %Credential{client_id: "test", secret_key: "111111"},
  %Credential{client_id: "sample", secret_key: "aaaaa"},
  %Credential{client_id: "invalid", secret_key: "111111", disabled: true}
]
|> Enum.each(SeedHelper.insert)


[
  %Node{hostname: "node1", credential: SeedHelper.get_credential("test")},
  %Node{hostname: "node2", credential: SeedHelper.get_credential("test")},
  %Node{hostname: "node1", credential: SeedHelper.get_credential("sample")},
  %Node{hostname: "node2", credential: SeedHelper.get_credential("sample")}
]
|> Enum.map(SeedHelper.update_last_beat)
|> Enum.each(SeedHelper.insert)