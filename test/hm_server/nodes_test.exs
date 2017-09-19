defmodule HMServer.NodeTest do
  use HMServerWeb.ConnCase

  alias HMServer.Repo, as: Repo
  alias HMServer.Credential, as: Credential

  defp validate!(item, params) do
    assert params.hostname == item.hostname
    assert datetimes_match(params.last_beat, item.last_beat)
    assert params.failure_count == item.failure_count
    assert params.disabled == item.disabled
    assert params.credential_id == item.credential_id

    item
  end

  describe "get_by!" do
    test "returns a new node if it is not already saved" do
      cred = insert!(:credential)
      insert!(:node, %{credential: cred})

      assert node = HMServer.Node.get_by!("new_host", cred)
      |> validate!(%{
        hostname: "new_host",
        last_beat: DateTime.utc_now,
        failure_count: 0,
        disabled: false,
        credential_id: nil
      })
      assert cred == node.credential
    end

    test "reads an existing node" do
      insert!(:credential, %{client_id: "ignored"})
      cred = insert!(:credential)
      insert!(:node, %{credential: cred, hostname: "ignored"})
      insert!(:node, %{credential: cred, failure_count: 2, disabled: true})

      HMServer.Node.get_by!(default_hostname(), cred)
      |> validate!(%{
        hostname: default_hostname(),
        last_beat: DateTime.utc_now,
        failure_count: 2,
        disabled: true,
        credential_id: cred.id
      })
    end
  end

  describe "update!" do
    defp expected_params() do
      cred = Credential.get_by!(default_user())

      %{
        hostname: default_hostname(),
        last_beat: DateTime.utc_now,
        failure_count: 0,
        disabled: false,
        credential_id: cred.id
      }
    end

    test "returns the item unmodified when it is disabled" do
      node = build(:node, %{failure_count: 2, disabled: true})

      assert node == node |> HMServer.Node.update!
    end

    test "inserts a new item" do
      cred = insert!(:credential)
      node = build(:node, %{credential: cred})

      assert inserted_node = node |> HMServer.Node.update!
      inserted_node |> validate!(expected_params())

      assert repo_node = HMServer.Node |> Repo.get_by!(%{id: inserted_node.id})
      repo_node |> validate!(expected_params())
    end

    test "updates an existing item" do
      cred = insert!(:credential)
      insert!(:node, %{credential: cred, failure_count: 2})
      node = HMServer.Node |> Repo.get_by!(hostname: default_hostname())

      assert inserted_node = node |> HMServer.Node.update!
      inserted_node |> validate!(expected_params())

      assert repo_node = HMServer.Node |> Repo.get_by!(%{id: inserted_node.id})
      repo_node |> validate!(expected_params())
    end
  end
end