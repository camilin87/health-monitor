# Script to enable/disable a Node
# It can be run like this
#    mix ops.node.enable --client-id test --node node1
#    mix ops.node.disable --client-id test --node node1
#

require Logger
alias HMServer.Repo, as: Repo

Logger.info "Node.Status"

argv = System.argv()
Logger.debug "argv=#{inspect argv}"

switches_spec = [enabled: :boolean, client_id: :string, node: :string]
parsed_args = OptionParser.parse!(argv, strict: switches_spec)
Logger.debug "parsed_args=#{inspect parsed_args}"

case parsed_args do
  {[enabled: enabled, client_id: client_id, node: hostname], []} ->
    Logger.debug "enabled=#{enabled}; client_id=#{client_id}; node=#{hostname};"

    credential = HMServer.Credential.get_by!(client_id)
    node = HMServer.Node.get_by!(hostname, credential)
    node
    |> Ecto.Changeset.change(disabled: !enabled)
    |> Repo.update!

    Logger.info "Success!!"
  _ ->
    Logger.error "Received Invalid Arguments!!"
    exit(1)
end
