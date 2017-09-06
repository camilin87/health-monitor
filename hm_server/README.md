# HMServer  

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# Api Docs  

## `GET /api/status`  

```bash
curl -w '\n' -i http://localhost:4000/api/status
```

Returns whether the api is operational or not. Anything but a `200` should be considered an error.  

## `POST /api/beat`  

```bash
curl -w '\n' -i -X POST \
  http://localhost:4000/api/beat \
  -u 'test:111111' \
  -F hostname=node2
```

Saves a hearbeat from a host. Anything but a `200` should be considered an error.  

This endpoint requires an `api_key` and `api_secret` to be transmitted in compliance with the [Basic HTTP Authentication Scheme](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication#Basic_authentication_scheme).  

The `hostname` field is the name of the node to monitor. An alert will be triggered if the node has stayed silent for a long period of time.
