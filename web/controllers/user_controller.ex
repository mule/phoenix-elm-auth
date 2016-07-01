defmodule PhoenixAuthKata.UserController do
    use PhoenixAuthKata.Web, :controller

    def show(conn, %{"id" => id}) do
        user = Repo.get(PhoenixAuthKata.User, id)
        json(conn, user)
    end


end