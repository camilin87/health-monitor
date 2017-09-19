# Script to create a Credential
# It can be run like this
#    mix ops.credential.create --client-id "aaaaa" --secret "super secret"
#

require Logger
alias HMServer.Repo, as: Repo
alias HMServer.Credential, as: Credential

Logger.info "Credential.Create"

argv = System.argv()
Logger.debug "argv=#{inspect argv}"

switches_spec = [client_id: :string, secret: :string]
parsed_args = OptionParser.parse!(argv, strict: switches_spec)
Logger.debug "parsed_args=#{inspect parsed_args}"

case parsed_args do
  {[client_id: client_id, secret: secret], []} ->
    Logger.debug "client_id=#{client_id}; secret=#{secret};"

    %Credential{client_id: client_id, secret_key: secret}
    |> Repo.insert!

    Logger.info "Success!!"
  _ ->
    Logger.error "Received Invalid Arguments!!"
    exit(1)
end
