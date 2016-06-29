defmodule PhoenixAuthKata.AuthControllerTest do
  use PhoenixAuthKata.ConnCase
  test "GET /", %{conn: conn} do
    expected_redirect_url = Google.authorize_url!(scope: "email profile")
    conn = get( conn, auth_path(conn, :index, "google"))  
    assert redirected_to(conn, 302) =~ expected_redirect_url
  end
end