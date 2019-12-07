defmodule CashHold.Repo.Migrations.AddBalanceTooBankAccount do
  use Ecto.Migration

  def change do
    alter table("bank_account") do
      add :current_balance, :integer      
    end
  end
end
