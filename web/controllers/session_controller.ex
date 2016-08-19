defmodule PhoenixAuthKata.SessionController do
    use PhoenixAuthKata.Web, :controller

    def index(conn, _params) do
        user = conn.assigns[:current_user]
        case is_nil(user) do
            true ->
                conn
                |> json(%{authenticated: false})
            false ->
                conn
                |> json(%{authenticated: true, userId: user.id, name: user.display_name})
        end
    end

    def create(conn, %{"email" => email, "password" => pass }) do
        case PhoenixAuthKata.Auth.login_by_username_and_password(conn, email, pass, repo: Repo) do
            {:ok, conn} ->
                user = conn.assigns[:current_user]
                conn
                |> json(%{authenticated: true, userId: user.id, name: user.display_name})
            {:error, :unauthorized, conn} ->
                conn
                |> put_status(401)
                |> json(%{ok: false, errors: ["Invalid password"]})
                |> halt()
            {:error, :not_found, conn} ->
                conn
                |> put_status(401)
                |> json(%{ok: false, errors: ["User with this email does not exist"]})
                |> halt()
        end
    end

    def delete(conn, _) do
        conn 
        |> PhoenixAuthKata.Auth.logout()
        |> redirect to: page_path(conn, :index)
    end
end