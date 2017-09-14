# HMServer  

A Heartbeat system to monitor the health of remote clients  

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

# [Development Docs](readme-dev.md)  
# [Operational Guides](readme-ops.md)  