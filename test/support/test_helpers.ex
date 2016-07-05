defmodule PhoenixAuthKata.TestHelpers do
    alias PhoenixAuthKata.Repo

    def insert_user(attrs \\ %{}) do
        changes = Dict.merge(%{
            email: "test.user.#{Base.encode16(:crypto.rand_bytes(8))}@phoenixauthkata.com",
            display_name: "Test User",
            password: "2Secret4U"},
            attrs)

        %PhoenixAuthKata.User{} 
        |> PhoenixAuthKata.User.registration_changeset(changes)
        |> Repo.insert!()
    end

end