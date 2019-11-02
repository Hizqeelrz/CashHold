defmodule CashHold.Banks.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bank_account" do
    field :account_number, :string
    field :account_title, :string
    field :account_type, :string
    field :bank_name, :string
    field :branch_address, :string
    field :branch_name, :string
    field :branch_number, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [:account_title, :account_number, :account_type, :bank_name, :branch_name, :branch_address, :branch_number, :user_id])
    |> validate_required([:account_title, :account_number, :bank_name, :branch_name, :branch_address, :branch_number])
  end
end
