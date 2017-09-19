defmodule HMServerWeb.Router do
  use HMServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HMServerWeb.ApiStatus
  end

  # Other scopes may use custom stacks.
  scope "/api", HMServerWeb do
    pipe_through :api

    resources "/status", ApiStatusController, only: [:index]
    resources "/beat", ApiBeatController, only: [:create]
  end
end
