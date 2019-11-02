defmodule CashHold.Repo.Migrations.CreateBankAccount do
  use Ecto.Migration

  def change do
    create table(:bank_account, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_title, :string
      add :account_number, :string
      add :account_type, :string
      add :bank_name, :string
      add :branch_name, :string
      add :branch_address, :string
      add :branch_number, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:bank_account, [:user_id])
  end
end
