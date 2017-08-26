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

HMServer.Repo.insert!(%HMServer.Credential{client_id: "test", secret_key: "111111"})
HMServer.Repo.insert!(%HMServer.Credential{client_id: "sample", secret_key: "aaaaa"})
HMServer.Repo.insert!(%HMServer.Credential{client_id: "invalid", secret_key: "111111", client_disabled: true})
