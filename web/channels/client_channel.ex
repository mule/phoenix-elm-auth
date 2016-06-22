defmodule PhoenixAuthKata.ClientChannel do
use Phoenix.Channel
require Logger


  def join("clients:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end