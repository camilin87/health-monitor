# Operational Guides  
The following assumes the application is running on Heroku. The [following guide](https://hexdocs.pm/phoenix/heroku.html) was used to deploy the app.  

## Required environment variables  

- `HOST_URL`: the hostname of the deployed app. e.g. `hmapi.herokuapp.com`
- `SECRET_KEY_BASE`: [docs in the deployment guide](https://hexdocs.pm/phoenix/heroku.html)
- `DATABASE_URL`: This one gets autopopulated once the database gets created with the postgres add-on
- `POOL_SIZE`: [docs in the deployment guide](https://hexdocs.pm/phoenix/heroku.html)

## Remote Commands Prerequisites  

Make sure to have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

    heroku login

Configure an environment variable with the Heroku app name  

    HEROKU_APP=hmapi

## Migrate the database  

    heroku run "POOL_SIZE=2 mix ecto.migrate" --app $HEROKU_APP

## Create a Credential  

    heroku run "POOL_SIZE=2 mix ops.credential.create --client-id test --secret \"111111\"" --app $HEROKU_APP

## Update a Credential  

    heroku run "POOL_SIZE=2 mix ops.credential.update --client-id test --secret \"AAAAAA\"" --app $HEROKU_APP

## Disable a Credential  

    heroku run "POOL_SIZE=2 mix ops.credential.disable --client-id test" --app $HEROKU_APP

## Enable a Credential  

    heroku run "POOL_SIZE=2 mix ops.credential.enable --client-id test" --app $HEROKU_APP

## Disable a Node  

    heroku run "POOL_SIZE=2 mix ops.node.disable --client-id test --node node1" --app $HEROKU_APP

## Enable a Node  

    heroku run "POOL_SIZE=2 mix ops.node.enable --client-id test --node node1" --app $HEROKU_APP

## Send a heartbeat  

```bash
curl -w '\n' -i -X POST \
  https://hmapi.herokuapp.com/api/beat \
  -u 'test:111111' \
  -F hostname=node1
```
