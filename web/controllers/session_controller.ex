defmodule PhoenixAuthKata.SessionController do
    use PhoenixAuthKata.Web, :controller

    def create(conn, %{"session" => %{"email" => email, "password" => pass }}) do
        case PhoenixAuthKata.Auth.login_by_username_and_passwod(conn, email, pass, repo: Repo) do
            {:ok, conn} ->
                conn
                |> json(%{ok: true})
            {:error, _reason, conn} ->
                conn
                |> json(%{ok: false, message: "Invalid username/password"})
        end
    end

    def delete(conn, _) do
        conn 
        |> PhoenixAuthKata.Auth.logout()
        |> json(%{ok: true})
    end
end