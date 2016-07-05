defmodule PhoenixAuthKata.Auth do
    import Plug.Conn

    def init(opts) do 
        Keyword.fetch!(opts, :repo)
    end

    def call(conn, repo) do
        user_id = get_session(conn, :user_id)

        cond do
            user = conn.assigns[:current_user] -> conn
            user = user_id && repo.get(PhoenixAuthKata.User, user_id) -> assign(conn, :current_user, user)
            true -> assign(conn, :current_user, nil)
        end

    end


end