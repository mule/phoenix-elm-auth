defmodule PhoenixAuthKata.Auth do
    import Plug.Conn

    def init(opts) do 
        Keyword.fetch!(opts, :repo)
    end

    def call(conn, reop) do
        user_id = get_session(conn, :user_id)
        user = user_id && repo.get(PhoenixAuthKata.User, user_id)
        assign(conn, :current_user, user)
    end


end