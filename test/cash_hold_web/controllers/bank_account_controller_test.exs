defmodule CashHoldWeb.BankAccountControllerTest do
  use CashHoldWeb.ConnCase

  alias CashHold.Banks
  alias CashHold.Banks.BankAccount

  @create_attrs %{
    account_number: "some account_number",
    account_title: "some account_title",
    account_type: "some account_type",
    bank_name: "some bank_name",
    branch_address: "some branch_address",
    branch_name: "some branch_name",
    branch_number: "some branch_number"
  }
  @update_attrs %{
    account_number: "some updated account_number",
    account_title: "some updated account_title",
    account_type: "some updated account_type",
    bank_name: "some updated bank_name",
    branch_address: "some updated branch_address",
    branch_name: "some updated branch_name",
    branch_number: "some updated branch_number"
  }
  @invalid_attrs %{account_number: nil, account_title: nil, account_type: nil, bank_name: nil, branch_address: nil, branch_name: nil, branch_number: nil}

  def fixture(:bank_account) do
    {:ok, bank_account} = Banks.create_bank_account(@create_attrs)
    bank_account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bank_account", %{conn: conn} do
      conn = get(conn, Routes.bank_account_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bank_account" do
    test "renders bank_account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bank_account_path(conn, :create), bank_account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bank_account_path(conn, :show, id))

      assert %{
               "id" => id,
               "account_number" => "some account_number",
               "account_title" => "some account_title",
               "account_type" => "some account_type",
               "bank_name" => "some bank_name",
               "branch_address" => "some branch_address",
               "branch_name" => "some branch_name",
               "branch_number" => "some branch_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bank_account_path(conn, :create), bank_account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bank_account" do
    setup [:create_bank_account]

    test "renders bank_account when data is valid", %{conn: conn, bank_account: %BankAccount{id: id} = bank_account} do
      conn = put(conn, Routes.bank_account_path(conn, :update, bank_account), bank_account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bank_account_path(conn, :show, id))

      assert %{
               "id" => id,
               "account_number" => "some updated account_number",
               "account_title" => "some updated account_title",
               "account_type" => "some updated account_type",
               "bank_name" => "some updated bank_name",
               "branch_address" => "some updated branch_address",
               "branch_name" => "some updated branch_name",
               "branch_number" => "some updated branch_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bank_account: bank_account} do
      conn = put(conn, Routes.bank_account_path(conn, :update, bank_account), bank_account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bank_account" do
    setup [:create_bank_account]

    test "deletes chosen bank_account", %{conn: conn, bank_account: bank_account} do
      conn = delete(conn, Routes.bank_account_path(conn, :delete, bank_account))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bank_account_path(conn, :show, bank_account))
      end
    end
  end

  defp create_bank_account(_) do
    bank_account = fixture(:bank_account)
    {:ok, bank_account: bank_account}
  end
end
