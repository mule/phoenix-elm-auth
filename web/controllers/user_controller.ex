defmodule PhoenixAuthKata.UserController do
    use PhoenixAuthKata.Web, :controller
    plug :authenticate when action in [:show]
    alias PhoenixAuthKata.User

    def show(conn, %{"id" => id}) do
            user = Repo.get(PhoenixAuthKata.User, id)
            response = 
            json(conn, user)
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.registration_changeset(%User{}, user_params)

        case Repo.insert(changeset) do
            {:ok, user} -> 
                conn 
                |> PhoenixAuthKata.Auth.login(user)
                |> json(%{ok: true, data: user})
            {:error, changeset} ->
                errors = Enum.into(changeset.errors, %{})
                conn
                |> put_status(422)
                |> json(%{ok: false, errors: errors })
                |> halt()
        end
    end

    defp authenticate(conn, _opts) do
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