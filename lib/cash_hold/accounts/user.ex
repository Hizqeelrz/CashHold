defmodule CashHold.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :avatar, :string
    field :email, :string
    field :first_name, :string
    field :is_deleted, :boolean, default: false
    field :last_name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password_hash, :avatar, :is_deleted])
    |> validate_required([:first_name, :last_name, :email, :password_hash, :avatar, :is_deleted])
  end
end
