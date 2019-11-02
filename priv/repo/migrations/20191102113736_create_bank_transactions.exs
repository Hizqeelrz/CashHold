defmodule CashHold.Repo.Migrations.CreateBankTransactions do
  use Ecto.Migration

  def change do
    create table(:bank_transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :balance, :string
      add :deposit_amount, :string
      add :withdraw_amount, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :bank_account_id, references(:bank_account, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:bank_transactions, [:user_id])
    create index(:bank_transactions, [:bank_account_id])
  end
end
