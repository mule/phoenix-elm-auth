defmodule PhoenixAuthKata.User do
  use PhoenixAuthKata.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    field :display_name, :string

    timestamps
  end

  @required_fields ~w(email password crypted_password display_name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email display_name), @optional_fields)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> put_pass_hash()
  end

    defp put_pass_hash(changeset) do
        case changeset do
            %Ecto.Changeset{valid?: true, changes: %{ password: pass}} ->
            put_change(changeset, :crypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
         _ ->
            changeset
        end
    end
end
