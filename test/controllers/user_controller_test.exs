defmodule PhoenixAuthKata.UserControllerTest do
    require Logger

    use PhoenixAuthKata.ConnCase

    test "GET user by id", %{conn: conn} do
        conn = get( conn, user_path( conn, :show, "1" ))
        assert conn.resp_body != "null"
       

    end
end