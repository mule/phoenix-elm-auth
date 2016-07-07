defmodule PhoenixAuthKata.AuthController do
    use PhoenixAuthKata.Web, :controller

    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

    def index(conn, %{ "provider" => provider }) do
        redirect conn, external: authorize_url!(provider)
    end

    def callback( conn, %{ "provider" => provider, "code" => code }) do
        token = get_token!(provider, code)
        user = get_user!(provider, token)

        conn
        |> put_session(:current_user, user)
        |> put_session(:access_token, token.access_token)
        |> redirect(to: "/")
    end

    def login(conn, user) do
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
    end

    def  login_with_username_and_password(conn, email, password, opts) do
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

    def logout(conn) do
        configure_session(conn, drop: true)
    end     

    defp authorize_url!("google") do
        Google.authorize_url!(scope: "email profile")
    end

    defp authorize_url!(_) do
        raise "No matching provider available"
    end

    defp get_token!("google", code) do
        Google.get_token!(code: code)
    end

    defp get_token!(_, _) do
        raise "No matching provider available"
    end

    defp get_user!("google", token) do
        user_url = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"
        OAuth2.AccessToken.get!(token, user_url)
    end


end

