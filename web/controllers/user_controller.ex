defmodule PhoenixAuthKata.UserController do
    use PhoenixAuthKata.Web, :controller

    def show(conn, %{"id" => id}) do
        case authenticate(conn) do
            %Plug.Conn{halted: true} = conn ->
                conn
            conn ->
                user = Repo.get(PhoenixAuthKata.User, id)
                response = 
                json(conn, user)
        end
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.registration_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} -> 
                conn 
                |> PhoenixAuthKata.auth.login(user)
                |> json(%{ok: true})
            {:error, changeset} ->
                json(%{ok: false})
        end
    end

    defp authenticate(conn) do
        if conn.assigns.current_user do
            conn
        else
            conn 
            |> put_status(401)
            |> json(%{ok: false})
            |> halt()
        end
    end


end