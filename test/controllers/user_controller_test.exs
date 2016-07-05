defmodule PhoenixAuthKata.UserControllerTest do
    require Logger
    use PhoenixAuthKata.ConnCase
    alias PhoenixAuthKata.User

    setup do
        user = insert_user()
        conn = assign(conn(), :current_user, user)
        {:ok, conn: conn, user: user}
    end

    test "GET user by id", %{conn: conn, user: user} do

        

        conn = get( conn, user_path( conn, :show, user.id ))
        IO.inspect conn.resp_body
        assert conn.resp_body != "null"
        result = Poison.decode!(conn.resp_body, as: %User{})
        actual = Map.merge(user, result)
        assert actual == user
    end
end