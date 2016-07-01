defmodule PhoenixAuthKata.Router do
    use PhoenixAuthKata.Web, :router

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

    scope "/", PhoenixAuthKata do
      pipe_through :browser # Use the default browser stack

      get "/", PageController, :index
    end

    scope "/auth", PhoenixAuthKata do
      pipe_through :browser # Use the default browser stack

      get "/:provider", AuthController, :index
      get "/:provider/callback", AuthController, :callback
    end

    scope "/user", PhoenixAuthKata do
      pipe_through :browser

      get("/show/:id", UserController, :show)
    end

    # Other scopes may use custom stacks.
    # scope "/api", PhoenixAuthKata do
    #   pipe_through :api
    # end
end
