defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RumblWeb.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RumblWeb do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end