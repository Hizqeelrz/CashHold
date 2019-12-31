defmodule CashHoldWeb.Api.BankTransactionController do
  use CashHoldWeb, :controller

  alias CashHold.Banks
  alias CashHold.Banks.BankTransaction
  alias CashHold.Repo

  require Ecto.Query

  action_fallback CashHoldWeb.FallbackController

  def index(conn, params) do
    bank_transactions = Banks.list_bank_transactions(params)
    render(conn, "index.json", bank_transactions: bank_transactions)
  end

  def create(conn, bank_transaction_params) do
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

  def export(conn, _params) do
    headers = "Id;Balance;Deposit_amount;Withdraw_amount;User_d;Bank_Account_Id;Inserted_at;\n"
    csv_content = [headers | csv_content]
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"BankTransaction.csv\"")
    |> send_resp(200, csv_content)
  end

  def import(conn, _params) do
    file = ("/home/hizqeel/Downloads/BankTransaction.csv")

    file
    |> File.stream!()
    |> Stream.map(&(&1))
    |> CSV.decode!(separator: ?;, validate_row_length: false, headers: [:id, :balance, :deposit_amount, 
                                                                        :withdraw_amount, :user_id, 
                                                                        :bank_account_id, :inserted_at])
    |> Enum.take_while(fn x -> x > 1 end)
    |> Enum.each(fn bank -> CashHold.Banks.BankTransaction.changeset(%BankTransaction{}, IO.isnpect bank) |> Repo.insert end)
  end

  defp csv_content do
    csv_content = 
      Banks.csv_to_export
      |> Enum.map(fn %{id: id, balance: balance, deposit_amount: damount, withdraw_amount: wamount, user_id: ui, bank_account_id: bai, inserted_at: ia} -> 
        "#{id};#{balance};#{damount};#{wamount};#{ui};#{bai};#{ia}\n"
      end)
  end
end