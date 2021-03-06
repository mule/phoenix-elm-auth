defmodule PhoenixAuthKata.UserTest do
  use PhoenixAuthKata.ModelCase

  alias PhoenixAuthKata.User

  @valid_attrs %{password: "some content", email: "some content", crypted_password: "tsfs", display_name: "test user" }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
