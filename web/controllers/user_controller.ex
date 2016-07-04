defmodule PhoenixAuthKata.UserController do
    use PhoenixAuthKata.Web, :controller

    def show(conn, %{"id" => id}) do
        case authenticate(conn) do
            %Plug.Conn{halted: true} = conn ->
                conn
            conn ->
                user = Repo.get(PhoenixAuthKata.User, id)
                json(conn, user)
    end

    defp authenticate(conn) do
        if conn.assigns.current_user do
            conn
        else
            conn 
            |> put_status(401)
            |> json %{ok: false}
            |> halt()
        end
    end

end