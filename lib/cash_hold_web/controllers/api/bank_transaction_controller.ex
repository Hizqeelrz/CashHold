defmodule CashHoldWeb.Api.BankTransactionController do
  use CashHoldWeb, :controller

  alias CashHold.Banks
  alias CashHold.Banks.BankTransaction
  alias CashHold.Repo

  require Ecto.Query

  action_fallback CashHoldWeb.FallbackController

  def index(conn, params) do

    IO.inspect params

    if params["balance"] do
      val = params["balance"]
      val = String.to_float(val)
      val = floor(val * 100)
      params = Map.put(params, "balance", val)

      bank_transactions = Banks.list_bank_transactions(params)
      render(conn, "index.json", bank_transactions: bank_transactions)
    else
      bank_transactions = Banks.list_bank_transactions(params)
      render(conn, "index.json", bank_transactions: bank_transactions)
    end

    # if (params["inserted_at"]) do
    #   val = params["inserted_at"]
    #   val = NaiveDateTime.to_date(val)
    #   params = Map.put(params, "inserted_at", val)

    #   bank_transactions = Banks.list_bank_transactions(params)
    #   render(conn, "index.json", bank_transactions: bank_transactions)
    # else
    #   bank_transactions = Banks.list_bank_transactions(params)
    #   render(conn, "index.json", bank_transactions: bank_transactions)
    # end
  end

  def create(conn, bank_transaction_params) do

    last_transaction = Banks.account_last_transaction

    case last_transaction do
      nil ->
        bank_transaction_params = Banks.sum_up_for_nil(bank_transaction_params)

        with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
          |> render("show.json", bank_transaction: bank_transaction)
        end
      last_transaction ->
        if (bank_transaction_params["deposit_amount"] !== nil) do

          bank_transaction_params = Banks.sum_up_for_deposit(last_transaction, bank_transaction_params)

          with {:ok, %BankTransaction{} = bank_transaction} <- Banks.create_bank_transaction(bank_transaction_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.bank_transaction_path(conn, :show, bank_transaction))
            |> render("show.json", bank_transaction: bank_transaction)
          end
        else if ( bank_transaction_params["withdraw_amount"] !== nil) do

          bank_transaction_params = Banks.sub_withdraw_amount(last_transaction, bank_transaction_params)

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
