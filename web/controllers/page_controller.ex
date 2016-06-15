defmodule PhoenixAuthKata.PageController do
  use PhoenixAuthKata.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
