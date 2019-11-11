defmodule CashHoldWeb.Api.BankTransactionView do
  use CashHoldWeb, :view
  alias CashHoldWeb.Api.BankTransactionView

  def render("index.json", %{bank_transactions: bank_transactions}) do
    %{data: render_many(bank_transactions, BankTransactionView, "bank_transaction.json")}
  end

  def render("show.json", %{bank_transaction: bank_transaction}) do
    %{data: render_one(bank_transaction, BankTransactionView, "bank_transaction.json")}
  end

  def render("bank_transaction.json", %{bank_transaction: bank_transaction}) do
    %{id: bank_transaction.id,
      balance: bank_transaction.balance / 100,
      deposit_amount: bank_transaction.deposit_amount,
      withdraw_amount: bank_transaction.withdraw_amount,
    }
  end
end
