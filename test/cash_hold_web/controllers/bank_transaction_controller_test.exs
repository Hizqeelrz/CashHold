defmodule CashHoldWeb.BankTransactionControllerTest do
  use CashHoldWeb.ConnCase

  alias CashHold.Banks
  alias CashHold.Banks.BankTransaction

  @create_attrs %{
    balance: "some balance",
    deposit_amount: "some deposit_amount",
    withdraw_amount: "some withdraw_amount"
  }
  @update_attrs %{
    balance: "some updated balance",
    deposit_amount: "some updated deposit_amount",
    withdraw_amount: "some updated withdraw_amount"
  }
  @invalid_attrs %{balance: nil, deposit_amount: nil, withdraw_amount: nil}

  def fixture(:bank_transaction) do
    {:ok, bank_transaction} = Banks.create_bank_transaction(@create_attrs)
    bank_transaction
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bank_transactions", %{conn: conn} do
      conn = get(conn, Routes.bank_transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bank_transaction" do
    test "renders bank_transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bank_transaction_path(conn, :create), bank_transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bank_transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "some balance",
               "deposit_amount" => "some deposit_amount",
               "withdraw_amount" => "some withdraw_amount"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bank_transaction_path(conn, :create), bank_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bank_transaction" do
    setup [:create_bank_transaction]

    test "renders bank_transaction when data is valid", %{conn: conn, bank_transaction: %BankTransaction{id: id} = bank_transaction} do
      conn = put(conn, Routes.bank_transaction_path(conn, :update, bank_transaction), bank_transaction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bank_transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "some updated balance",
               "deposit_amount" => "some updated deposit_amount",
               "withdraw_amount" => "some updated withdraw_amount"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bank_transaction: bank_transaction} do
      conn = put(conn, Routes.bank_transaction_path(conn, :update, bank_transaction), bank_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bank_transaction" do
    setup [:create_bank_transaction]

    test "deletes chosen bank_transaction", %{conn: conn, bank_transaction: bank_transaction} do
      conn = delete(conn, Routes.bank_transaction_path(conn, :delete, bank_transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bank_transaction_path(conn, :show, bank_transaction))
      end
    end
  end

  defp create_bank_transaction(_) do
    bank_transaction = fixture(:bank_transaction)
    {:ok, bank_transaction: bank_transaction}
  end
end
