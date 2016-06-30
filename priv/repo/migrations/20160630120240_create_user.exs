defmodule PhoenixAuthKata.Repo.Migrations.CreateUser do
    use Ecto.Migration

    def change do
                create table(:users) do
            add :display_name, :string, null: false
            add :email, :string, null: false
            add :crypted_password, :string

            timestamps
        end

    create unique_index(:users, [:email])

    end
end

