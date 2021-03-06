defmodule PhoenixAuthKata.Router do
    use PhoenixAuthKata.Web, :router

    pipeline :browser do
      plug :accepts, ["html"]
      plug :fetch_session
      plug :fetch_flash
      plug :protect_from_forgery
      plug :put_secure_browser_headers
        plug PhoenixAuthKata.Auth, repo: PhoenixAuthKata.Repo
    end

    pipeline :api do
      plug :accepts, ["json"]
      plug :fetch_session
      plug PhoenixAuthKata.Auth, repo: PhoenixAuthKata.Repo
    end

    scope "/", PhoenixAuthKata do
      pipe_through :browser # Use the default browser stack

      get "/", PageController, :index
    end

    scope "/auth", PhoenixAuthKata do
      pipe_through :browser # Use the default browser stack

      get "/:provider", AuthController, :index
      get "/:provider/callback", AuthController, :callback
    end

    ##scope "/user", PhoenixAuthKata do
    ##  pipe_through :browser

    ##  get("/show/:id", UserController, :show)
    ##end

    scope "api", PhoenixAuthKata do
      pipe_through :api
      resources "/users/", UserController, only: [:show, :create]
      resources "/sessions/", SessionController, only: [:index, :create, :delete] 
    end
    
    # Other scopes may use custom stacks.
    # scope "/api", PhoenixAuthKata do
    #   pipe_through :api
    # end
end
