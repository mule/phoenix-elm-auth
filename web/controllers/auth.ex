defmodule PhoenixAuthKata.Auth do
    require Logger
    import Plug.Conn
    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]


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

    def login(conn, user) do
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    end

    def logout(conn) do
        configure_session(conn, drop: true)
    end   

    def  login_by_username_and_password(conn, email, password, opts) do
        Logger.debug email
        Logger.debug password
        repo = Keyword.fetch!(opts, :repo)
        user = repo.get_by(PhoenixAuthKata.User, email: email)

        cond do
            user && checkpw(password, user.crypted_password) ->
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn}        
        end
    end


end