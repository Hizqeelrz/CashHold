defmodule CashHoldWeb.Api.BankTransactionController do
  use CashHoldWeb, :controller

  alias CashHold.Banks
  alias CashHold.Banks.BankTransaction
  alias CashHold.Repo

  require Ecto.Query

  action_fallback CashHoldWeb.FallbackController

  def index(conn, _params) do
    bank_transactions = Banks.list_bank_transactions()
    render(conn, "index.json", bank_transactions: bank_transactions)
  end

  def create(conn, bank_transaction_params) do
    IO.inspect bank_transaction_params
    IO.inspect "Transaction post"

    query = Ecto.Query.from(u in BankTransaction) |> Ecto.Query.last(:inserted_at) |> Repo.one

    IO.inspect query

    case query do
      nil ->
        IO.inspect "1 is working"
        bank_transaction_params = Map.put(bank_transaction_params, "balance", 0)

        balance = bank_transaction_params["balance"]
        deposit_amount = bank_transaction_params["deposit_amount"]

        total_balance = balance + deposit_amount

        bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)

        with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
          |> render("show.json", bank_transaction: bank_transaction)
        end
      query ->
        if (bank_transaction_params["deposit_amount"] !== nil) do
          IO.inspect "We are inside deposit amount"
          bank_transaction_params = Map.put(bank_transaction_params, "balance", query.balance)
          IO.inspect bank_transaction_params
          IO.inspect "getting the struct with deposit as input"

          balance = bank_transaction_params["balance"]
          IO.inspect balance
          IO.inspect "getting last balance"

          deposit_amount = bank_transaction_params["deposit_amount"]

          total_balance = balance + deposit_amount

          bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)

          with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
            |> render("show.json", bank_transaction: bank_transaction)
          end
        else if ( bank_transaction_params["withdraw_amount"] !== nil) do
          IO.inspect "We are inside withdraw amount"
          bank_transaction_params = Map.put(bank_transaction_params, "balance", query.balance)
          IO.inspect bank_transaction_params
          IO.inspect "getting the struct with withdraw as input"


          balance = bank_transaction_params["balance"]
          IO.inspect balance
          IO.inspect "getting last balance"

          withdraw_amount = bank_transaction_params["withdraw_amount"]
          IO.inspect withdraw_amount
          IO.inspect "getting withdraw_amount above"

          total_balance = balance - withdraw_amount

          bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)

          with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
            |> render("show.json", bank_transaction: bank_transaction)
          end
        end
      end
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
