defmodule EulerTestWeb.Router do
  use EulerTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EulerTestWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/check-inn", CheckInnController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EulerTestWeb do
  #   pipe_through :api
  # end
end
