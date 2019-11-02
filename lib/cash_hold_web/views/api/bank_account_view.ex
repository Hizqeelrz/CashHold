defmodule CashHoldWeb.Api.BankAccountView do
  use CashHoldWeb, :view
  alias CashHoldWeb.Api.BankAccountView

  def render("index.json", %{bank_account: bank_account}) do
    %{data: render_many(bank_account, BankAccountView, "bank_account.json")}
  end

  def render("show.json", %{bank_account: bank_account}) do
    %{data: render_one(bank_account, BankAccountView, "bank_account.json")}
  end

  def render("bank_account.json", %{bank_account: bank_account}) do
    %{id: bank_account.id,
      account_title: bank_account.account_title,
      account_number: bank_account.account_number,
      account_type: bank_account.account_type,
      bank_name: bank_account.bank_name,
      branch_name: bank_account.branch_name,
      branch_address: bank_account.branch_address,
      branch_number: bank_account.branch_number}
  end
end
