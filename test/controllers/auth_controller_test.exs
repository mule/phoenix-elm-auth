defmodule PhoenixAuthKata.AuthControllerTest do
  use PhoenixAuthKata.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn, status \\ 302)
  end
end