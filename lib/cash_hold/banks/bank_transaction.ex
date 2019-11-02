defmodule CashHold.Banks.BankTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bank_transactions" do
    field :balance, :string
    field :deposit_amount, :string
    field :withdraw_amount, :string
    field :user_id, :binary_id
    field :bank_account_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(bank_transaction, attrs) do
    bank_transaction
    |> cast(attrs, [:balance, :deposit_amount, :withdraw_amount, :user_id, :bank_account_id])
    |> validate_required([:balance])
  end
end
