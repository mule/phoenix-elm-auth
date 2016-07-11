defmodule PhoenixAuthKata.UserControllerTest do
    require Logger
    use PhoenixAuthKata.ConnCase

    setup do
        user = insert_user()
        conn = assign(conn(), :current_user, user)
        {:ok, conn: conn, user: user}
    end

    test "GET user by id", %{conn: conn, user: user} do

        conn = get( conn, user_path( conn, :show, user.id ))
        IO.inspect conn.resp_body
        assert conn.resp_body != "null"
        actual = Poison.Parser.parse!(conn.resp_body, keys: :atoms!)
        expected = Map.take(user, [:email, :display_name])
        assert expected == actual
    end
    
    test "Create user", %{conn: conn} do
        conn = post(conn, user_path(conn, :create, %{user: %{email: "test.user@test.com", password: "secret", display_name: "test user"}}))
        actual = Poison.Parser.parse!(conn.resp_body, keys: :atoms!)
        expected = %{ok: true}

        assert expected == actual
    end

    test "Should fail in creating user", %{conn: conn} do
        conn = post(conn, user_path(conn, :create, %{user: %{display_name: "test user"}}))
        actual = Poison.Parser.parse!(conn.resp_body, keys: :atoms!)
        result = Map.take(actual, [:ok])
        expected = %{ok: false}

        assert expected == result
    end
end