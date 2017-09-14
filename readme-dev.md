# Development Guides  

## To start your Phoenix server  

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Server application creation  

    mix phx.new hm_server --module HMServer --no-brunch

## Stress testing  

```bash
echo "hostname=node" > .tmp && \
ab -A 'test:111111' \
    -T 'application/x-www-form-urlencoded' \
    -p .tmp \
    -n 100000 \
    -c 100 \
    http://127.0.0.1:4000/api/beat \
&& rm .tmp
```
