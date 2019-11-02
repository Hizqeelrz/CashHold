defmodule CashHoldWeb.Api.BankTransactionController do
  use CashHoldWeb, :controller

  alias CashHold.Banks
  alias CashHold.Banks.BankTransaction

  action_fallback CashHoldWeb.FallbackController

  def index(conn, _params) do
    bank_transactions = Banks.list_bank_transactions()
    render(conn, "index.json", bank_transactions: bank_transactions)
  end

  def create(conn, %{"bank_transaction" => bank_transaction_params}) do
    with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
      |> render("show.json", bank_transaction: bank_transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    bank_transaction = Banks.get_bank_transaction!(id)
    render(conn, "show.json", bank_transaction: bank_transaction)
  end

  def update(conn, %{"id" => id, "bank_transaction" => bank_transaction_params}) do
    bank_transaction = Banks.get_bank_transaction!(id)

    with {:ok, %BankTransaction{} = bank_transaction} <- Banks.update_bank_transaction(bank_transaction, bank_transaction_params) do
      render(conn, "show.json", bank_transaction: bank_transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    bank_transaction = Banks.get_bank_transaction!(id)

    with {:ok, %BankTransaction{}} <- Banks.delete_bank_transaction(bank_transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
