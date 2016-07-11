defmodule PhoenixAuthKata.AuthTest do
    use PhoenixAuthKata.ConnCase
    alias PhoenixAuthKata.Auth

    setup %{conn: conn} do
        user = insert_user()
        conn =
        conn
        |> bypass_through(PhoenixAuthKata.Router, :browser)
        |> get("/")

        {:ok, %{conn: conn, user: user}}
    end
    

    test "Should login user succesfully",  %{conn: conn, user: user} do
        conn = Auth.login(conn, user)
        assert conn.halted == false
        assert conn.assigns.current_user == user
    end

end