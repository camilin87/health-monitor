# Script to update a Credential
# It can be run like this
#    mix ops.credential.update --client-id "aaaaa" --secret "super secret"
#

require Logger
alias HMServer.Repo, as: Repo

Logger.info "Credential.Update"

argv = System.argv()
Logger.debug "argv=#{inspect argv}"

switches_spec = [client_id: :string, secret: :string]
parsed_args = OptionParser.parse!(argv, strict: switches_spec)
Logger.debug "parsed_args=#{inspect parsed_args}"

case parsed_args do
  {[client_id: client_id, secret: secret], []} ->
    Logger.debug "client_id=#{client_id}; secret=#{secret};"

    client_id
    |> HMServer.Credential.get_by!
    |> Ecto.Changeset.change(secret_key: secret)
    |> Repo.update!

    Logger.info "Success!!"
  _ ->
    Logger.error "Received Invalid Arguments!!"
    exit(1)
end
